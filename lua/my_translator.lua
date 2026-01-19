local M = {}

local source_buf = nil
local target_buf = nil
local debounce_timer = nil
local DEBOUNCE_MS = 1000

local dirty_lines = {}
local needs_full_sync = true

local line_jobs = {}
local full_job_id = nil

local function kill_job(id)
  if id and id > 0 then vim.fn.jobstop(id) end
end

local function cleanup()
  if debounce_timer then
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end
  kill_job(full_job_id)
  for _, id in pairs(line_jobs) do
    kill_job(id)
  end

  line_jobs = {}
  dirty_lines = {}
  source_buf = nil
  target_buf = nil
end

local function translate_single_line(line_idx, text, output_buf)
  kill_job(line_jobs[line_idx])

  if text == "" then
    if vim.api.nvim_buf_is_valid(output_buf) then
      vim.api.nvim_buf_set_lines(output_buf, line_idx, line_idx + 1, false, { "" })
    end
    return
  end

  local cmd = { "trans", "-b", "-t", "uk", "--no-ansi", "-e", "google" }
  local result_acc = {}

  local job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(result_acc, line) end
        end
      end
    end,
    on_exit = function(_, code)
      line_jobs[line_idx] = nil
      if code == 0 and vim.api.nvim_buf_is_valid(output_buf) then
        local translated_text = table.concat(result_acc, " ")

        if line_idx < vim.api.nvim_buf_line_count(output_buf) then
          vim.api.nvim_buf_set_lines(output_buf, line_idx, line_idx + 1, false, { translated_text })
        end
      end
    end,
  })

  line_jobs[line_idx] = job_id

  if job_id > 0 then
    vim.fn.chansend(job_id, { text })
    vim.fn.chanclose(job_id, "stdin")
  end
end

local function translate_full(text_lines, output_buf)
  kill_job(full_job_id)

  vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, {})

  local cmd = { "trans", "-b", "-t", "uk", "--no-ansi", "-e", "google" }
  local opts = {
    stdout_buffered = false,
    on_stdout = function(_, data, _)
      if not data then return end
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(output_buf) then return end
        local last_row = vim.api.nvim_buf_line_count(output_buf)
        local last_content = vim.api.nvim_buf_get_lines(output_buf, last_row - 1, last_row, false)[1] or ""
        data[1] = last_content .. data[1]
        vim.api.nvim_buf_set_lines(output_buf, last_row - 1, last_row, false, data)
      end)
    end,
    on_exit = function() full_job_id = nil end,
  }

  full_job_id = vim.fn.jobstart(cmd, opts)
  if full_job_id > 0 then
    vim.fn.chansend(full_job_id, text_lines)
    vim.fn.chanclose(full_job_id, "stdin")
  end
end

local function process_updates()
  if not target_buf or not vim.api.nvim_buf_is_valid(target_buf) then return end
  if not source_buf or not vim.api.nvim_buf_is_valid(source_buf) then return end

  local src_count = vim.api.nvim_buf_line_count(source_buf)
  local tgt_count = vim.api.nvim_buf_line_count(target_buf)

  if src_count ~= tgt_count then needs_full_sync = true end

  local dirty_count = 0
  for _ in pairs(dirty_lines) do
    dirty_count = dirty_count + 1
  end

  if needs_full_sync or dirty_count > 3 then
    local lines = vim.api.nvim_buf_get_lines(source_buf, 0, -1, false)
    translate_full(lines, target_buf)
  else
    for line_idx, _ in pairs(dirty_lines) do
      local line_text = vim.api.nvim_buf_get_lines(source_buf, line_idx, line_idx + 1, false)[1] or ""
      translate_single_line(line_idx, line_text, target_buf)
    end
  end

  needs_full_sync = false
  dirty_lines = {}
end

local function trigger_debounce()
  if debounce_timer then debounce_timer:stop() end
  debounce_timer = vim.loop.new_timer()
  debounce_timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(process_updates))
end

function M.start_split()
  source_buf = vim.api.nvim_get_current_buf()
  local filetype = vim.bo.filetype

  vim.cmd "vsplit"
  vim.cmd "wincmd l"
  vim.cmd "enew"

  target_buf = vim.api.nvim_get_current_buf()
  vim.bo[target_buf].buftype = "nofile"
  vim.bo[target_buf].bufhidden = "wipe"
  vim.bo[target_buf].filetype = filetype
  vim.wo.wrap = true
  vim.cmd "wincmd h"

  needs_full_sync = true
  process_updates()

  vim.api.nvim_buf_attach(source_buf, false, {
    on_lines = function(_, _, _, firstline, lastline, new_lastline, _)
      if (lastline - firstline) ~= (new_lastline - firstline) then
        needs_full_sync = true
      else
        for i = firstline, new_lastline - 1 do
          dirty_lines[i] = true
        end
      end

      trigger_debounce()
    end,

    on_detach = function() cleanup() end,
  })

  local target_win = vim.api.nvim_get_current_win()
end

vim.api.nvim_create_user_command("TranslateSplit", M.start_split, {})

return M
