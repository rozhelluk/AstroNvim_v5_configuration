return {
  {
    "local-translator",
    dir = vim.fn.stdpath "config",
    cmd = "TranslateSplit",
    keys = {
      { "<leader>tr", "<cmd>TranslateSplit<cr>", desc = "Translate Split (UA)" },
    },

    config = function() require "my_translator" end,
  },
}
