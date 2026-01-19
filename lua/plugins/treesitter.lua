-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "python",
      "bash",
      "nix",
      "cpp",
      "markdown",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
