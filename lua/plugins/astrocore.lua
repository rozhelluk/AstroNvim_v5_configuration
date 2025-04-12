-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 512, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        number = true,
        signcolumn = "auto",
        autochdir = true,
        relativenumber = true,
        spell = true,
        wrap = true,
        colorcolumn = "80,120",
        swapfile = false,
        encoding = "UTF-8",
        fileencoding = "UTF-8",
        tabstop = 4,
        showtabline = 2,
        laststatus = 2,
        scrolloff = 4,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        ["<Leader>,"] = {
          function() require("notify").dismiss { pending = true, silent = true } end,
          desc = "Dismiss notifications",
        },
        -- navigate buffer tabs
        ["<C-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<C-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        [";"] = { ":" },

        ["<M-l>"] = {
          function() vim.diagnostic.open_float() end,
          desc = "Hover diagnostics",
        },
        ["<M-K>"] = {
          function() require("astrocore.toggles").virtual_text() end,
          desc = "Toggle virtual text",
        },
        ["<M-k>"] = {
          function() require("astrocore.toggles").virtual_lines() end,
          desc = "Toggle virtual lines",
        },

        ["<F3>"] = { ":w<CR>:exec '!python3 -B' shellescape(@%, 1)<CR>" },
        ["<F4>"] = { ":w<CR>:vsplit term://python3 -B %<cr>i" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },

      i = {
        ["<F3>"] = { ":w<CR>:exec '!python3.11 -B' shellescape(@%, 1)<CR>" },
        ["<F4>"] = { ":w<CR>:vsplit term://python3.11 -B %<cr>i" },
      },

      v = {},
    },
  },
}
