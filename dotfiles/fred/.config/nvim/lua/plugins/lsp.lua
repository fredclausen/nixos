return {
    -- neodev
    -- {
    --   "folke/neodev.nvim",
    --   opts = {
    --     debug = true,
    --     experimental = {
    --       pathStrict = true,
    --     },
    --   },
    -- },
    {
      'neovim/nvim-lspconfig',
      opts = {
        setup = {
          rust_analyzer = function()
            return true
          end,
        }
      }
    },

    -- tools
    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "black",
          "eslint_d",
          "luacheck",
          "prettierd",
          "prosemd-lsp",
          "ruff",
          "rust-analyzer",
          "selene",
          "shellcheck",
          "shellharden",
          "shfmt",
          "stylua",
          "bash-language-server",
        },
      },
      enabled = function() return jit.os == "OSX" end
    },
}
