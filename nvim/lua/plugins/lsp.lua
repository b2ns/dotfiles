return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      diagnostics = {
        virtual_text = false,
        signs = false,
      },
      inlay_hints = {
        enabled = false,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
        "scss",
        "regex",
        "rust",
      })
    end,
  },

  -- dictionary completion
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      -- ... Other dependencies
    },
    opts = {
      sources = {
        -- Add 'dictionary' to the list
        -- default = { "dictionary", "lsp", "path", "luasnip", "buffer" },
        default = { "lsp", "path", "buffer", "dictionary" },
        providers = {
          dictionary = {
            module = "blink-cmp-dictionary",
            name = "Dict",
            -- Make sure this is at least 2.
            -- 3 is recommended
            min_keyword_length = 3,
            max_items = 8,
            -- sort it at the last
            score_offset = -10,
            opts = {
              dictionary_files = {
                vim.fn.expand("~/github/b2ns/dotfiles/nvim-resources/word.txt"),
              },
            },
          },
        },
      },
    },
  },
}
