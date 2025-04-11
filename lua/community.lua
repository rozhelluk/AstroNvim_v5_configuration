-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.bash" },

  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },

  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  { import = "astrocommunity.editing-support.dial-nvim" },
  { import = "astrocommunity.editing-support.hypersonic-nvim" },
  { import = "astrocommunity.editing-support.suda-vim" },

  { import = "astrocommunity.motion.vim-matchup" },
  { import = "astrocommunity.motion.nvim-surround" },

  { import = "astrocommunity.scrolling.cinnamon-nvim" },

  { import = "astrocommunity.file-explorer.oil-nvim" },

  -- { import = "astrocommunity.language.pantran-nvim" }, dev

  { import = "astrocommunity.register.nvim-neoclip-lua" },

  { import = "astrocommunity.workflow.hardtime-nvim" },
  {
    "hardtime.nvim",
    opts = {
      disable_mouse = false,
      max_count = 8,
      restriction_mode = "hint", -- block or hint
      disabled_keys = {},
    },
  },

  -- {
  --   "pantran-nvim",
  --
  --   require("pantran").setup {
  --     default_engine = "google",
  --     engines = {
  --       google = {
  --         default_source = "auto",
  --         default_target = "uk",
  --       },
  --     },
  --   },
  -- },
  -- { import = "astrocommunity.lsp.lsp-signature-nvim" },
}
