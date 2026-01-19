-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  {
    "andweeb/presence.nvim",
    config = function(_, opts)
      require("presence").setup {
        auto_update = true,
        neovim_image_text = "The One True Text Editor",
        main_image = "neovim",
        client_id = "793271441293967371",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = true,
        blacklist = {},
        buttons = true,
        file_assets = {},
        show_time = true,

        editing_text = "Editing...",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
      }
    end,
    -- event = "VeryLazy",
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            "▄▄▄        ·▄▄▄▄• ▄ .▄▄▄▄ .▄▄▌  ▄▄▌  ▄• ▄▌▄ •▄ ",
            "▀▄ █·▪     ▪▀·.█▌██▪▐█▀▄.▀·██•  ██•  █▪██▌█▌▄▌▪",
            "▐▀▀▄  ▄█▀▄ ▄█▀▀▀•██▀▐█▐▀▀▪▄██▪  ██▪  █▌▐█▌▐▀▀▄·",
            "▐█•█▌▐█▌.▐▌█▌▪▄█▀██▌▐▀▐█▄▄▌▐█▌▐▌▐█▌▐▌▐█▄█▌▐█.█▌",
            ".▀  ▀ ▀█▄▀▪·▀▀▀ •▀▀▀ · ▀▀▀ .▀▀▀ .▀▀▀  ▀▀▀ ·▀  ▀",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  -- { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("html", { "htmldjango" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "rozhelluk/pantran.nvim",
    config = function(plugin, opts)
      local pantran = require "pantran"
      pantran.setup {
        -- `:lua =vim.tbl_keys(require("pantran.engines"))`.
        default_engine = "google",
        engines = {
          google = {
            fallback = {
              default_source = "auto",
              default_target = "uk",
            },
          },
        },
        controls = {
          mappings = {
            edit = {
              n = {
                -- Use this table to add additional mappings for the normal mode in the translation window. Either strings or function references are supported.
                ["j"] = "gj",
                ["k"] = "gk",
              },
              i = {
                -- Similar table but for insert mode. Using 'false' disables
                -- existing keybindings.
                ["<C-y>"] = false,
                ["<C-a>"] = require("pantran.ui.actions").yank_close_translation,
              },
            },
            -- Keybindings here are used in the selection window.
            select = {
              n = {
                -- ...
              },
            },
          },
        },
      }
      local map = vim.keymap.set

      map(
        "n",
        "<leader>P",
        pantran.motion_translate(),
        { desc = "Pantran: Translate line", noremap = true, silent = true }
      )
      map(
        "n",
        "<M-p>",
        pantran.motion_translate(),
        { desc = "Pantran: Translate selection", noremap = true, silent = true }
      )
      map(
        "v",
        "<M-p>",
        pantran.motion_translate(),
        { desc = "Pantran: Translate selection", noremap = true, silent = true }
      )

      map(
        "v",
        "<leader>P",
        pantran.motion_translate(),
        { desc = "Pantran: Translate selection", noremap = true, silent = true }
      )

      map("n", "<leader>Pp", "<cmd>Pantran<CR>", { desc = "Pantran UI", noremap = true, silent = true })
    end,
  },
  {
    "vzze/calculator.nvim",
    vim.api.nvim_create_user_command(
      "Calculate",
      'lua require("calculator").calculate()',
      { ["range"] = 1, ["nargs"] = 0 }
    ),
  },
  -- { "danilamihailov/beacon.nvim" }, -- lazy calls setup() by itself
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   opts = {},
  -- },
}
