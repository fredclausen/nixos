return {
    {
      "zbirenbaum/copilot.lua",
      opts = {
        filetypes = { ["*"] = true },
        suggestion = { enabled = true, auto_trigger = true },
      },
    },

    {
      "smjonas/inc-rename.nvim",
      cmd = "IncRename",
      config = true,
    },

    -- {
    --   "echasnovski/mini.bracketed",
    --   enabled = false,
    --   event = "BufReadPost",
    --   config = function()
    --     local bracketed = require("mini.bracketed")
    --
    --     -- local function put(cmd, regtype)
    --     -- 	local body = vim.fn.getreg(vim.v.register)
    --     -- 	local type = vim.fn.getregtype(vim.v.register)
    --     -- 	---@diagnostic disable-next-line: param-type-mismatch
    --     -- 	vim.fn.setreg(vim.v.register, body, regtype or "l")
    --     -- 	bracketed.register_put_region()
    --     -- 	vim.cmd(('normal! "%s%s'):format(vim.v.register, cmd:lower()))
    --     -- 	---@diagnostic disable-next-line: param-type-mismatch
    --     -- 	vim.fn.setreg(vim.v.register, body, type)
    --     -- end
    --
    --     -- for _, cmd in ipairs({ "]p", "[p" }) do
    --     -- 	put(cmd)
    --     -- 	vim.keymap.set("n", cmd, function() end)
    --     -- end
    --     --
    --     -- for _, cmd in ipairs({ "]P", "[P" }) do
    --     -- 	vim.keymap.set("n", cmd, function()
    --     -- 		put(cmd, "c")
    --     -- 	end)
    --     -- end
    --
    --     -- local put_keys = { "p", "P" }
    --     -- for _, lhs in ipairs(put_keys) do
    --     -- 	vim.keymap.set({ "n", "x" }, lhs, function()
    --     -- 		return bracketed.register_put_region(lhs)
    --     -- 	end, { expr = true })
    --     -- end
    --
    --     bracketed.setup({
    --       file = { suffix = "" },
    --       window = { suffix = "" },
    --       quickfix = { suffix = "" },
    --       yank = { suffix = "" },
    --       treesitter = { suffix = "n" },
    --     })
    --   end,
    -- },

    -- better increase/decrease
    {
      "monaqa/dial.nvim",
      event = "VeryLazy",
      -- splutylua: ignore
      keys = {
        {
          "<C-a>",
          function()
            return require("dial.map").inc_normal()
          end,
          expr = true,
          desc = "Increment",
        },
        {
          "<C-x>",
          function()
            return require("dial.map").dec_normal()
          end,
          expr = true,
          desc = "Decrement",
        },
      },
      config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group({
          default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias["%Y/%m/%d"],
            augend.constant.alias.bool,
            augend.constant.new({ elements = { "let", "const" } }),
            augend.semver.alias.semver,
          },
        })
      end,
    },

    -- Supertab
    {
        "L3MON4D3/LuaSnip",
        keys = function()
          return {}
        end,
      },
    -- {
    --   "L3MON4D3/LuaSnip",
    --   opts = {
    --     history = true,
    --     region_check_events = "InsertEnter",
    --     delete_check_events = "TextChanged",
    --   },
    --   keys = function()
    --     return {}
    --   end,
    -- },

    -- {
    --     "hrsh7th/nvim-cmp",
    --     dependencies = {
    --       "hrsh7th/cmp-emoji",
    --       opts = nil,
    --     },
    --     ---@param opts cmp.ConfigSchema
    --     opts = function(_, opts)
    --       local has_words_before = function()
    --         unpack = unpack or table.unpack
    --         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    --       end

    --       local luasnip = require("luasnip")
    --       local cmp = require("cmp")

    --       opts.mapping = vim.tbl_extend("force", opts.mapping, {
    --         ["<CR>"] = vim.NIL,

    --         ["<Tab>"] = cmp.mapping(function(fallback)
    --           if cmp.visible() then
    --             cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
    --           elseif require("copilot.suggestion").is_visible() then
    --             require("copilot.suggestion").accept()
    --           elseif luasnip.expand_or_locally_jumpable() then
    --             luasnip.expand_or_jump()
    --           elseif has_words_before() then
    --             cmp.complete()
    --           else
    --             fallback()
    --           end
    --         end, { "i", "s" }),

    --         ["<S-Tab>"] = cmp.mapping(function(fallback)
    --           if cmp.visible() then
    --             cmp.select_prev_item()
    --           elseif luasnip.jumpable(-1) then
    --             luasnip.jump(-1)
    --           else
    --             fallback()
    --           end
    --         end, { "i", "s" }),
    --       })
    --       opts.preselect = cmp.PreselectMode.None
    --       opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    --     end,
    --   },

    {
      "Wansmer/treesj",
      keys = {
        { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
      },
      opts = { use_default_keymaps = false, max_join_length = 150 },
    },

    {
      "cshuaimin/ssr.nvim",
      keys = {
        {
          "<leader>sj",
          function()
            require("ssr").open()
          end,
          mode = { "n", "x" },
          desc = "Structural Replace",
        },
      },
    },

    -- {
    --   "gorbit99/codewindow.nvim",
    --   enabled = false,
    --   event = "BufReadPre",
    --   keys = {
    -- 	-- stylua: ignore
    -- 	{ "<leader>um", function() require("codewindow").toggle_minimap() end, desc = "Toggle Minimap" },
    --   },
    --   config = function()
    --     require("codewindow").setup({
    --       z_index = 25,
    --       auto_enable = true,
    --       exclude_filetypes = {
    --         "alpha",
    --         "dap-terminal",
    --         "DiffviewFiles",
    --         "git",
    --         "gitcommit",
    --         "help",
    --         "lazy",
    --         "lspinfo",
    --         "mason",
    --         "NeogitCommitMessage",
    --         "NeogitStatus",
    --         "neotest-summary",
    --         "neo-tree",
    --         "neo-tree-popup",
    --         "noice",
    --         "Outline",
    --         "qf",
    --         "spectre_panel",
    --         "toggleterm",
    --         "Trouble",
    --       },
    --     })
    --   end,
    -- },

    {
      "andythigpen/nvim-coverage",
      event = "VeryLazy",
      config = true,
    },
    {
      "vhyrro/luarocks.nvim",
      priority = 1000,
      config = true,
    },
    {
      "rest-nvim/rest.nvim",
      ft = "http",
      dependencies = {
        "luarocks.nvim"
      },
      config = function()
        require("rest-nvim").setup({
          -- Open request results in a horizontal split
          result_split_horizontal = true,
          -- Keep the http file buffer above|left when split horizontal|vertical
          result_split_in_place = false,
          -- Skip SSL verification, useful for unknown certificates
          skip_ssl_verification = false,
          -- Encode URL before making request
          encode_url = true,
          -- Highlight request on run
          highlight = {
            enabled = true,
            timeout = 150,
          },
          result = {
            -- toggle showing URL, HTTP info, headers at top the of result window
            show_url = true,
            show_http_info = true,
            show_headers = true,
            -- executables or functions for formatting response body [optional]
            -- set them to false if you want to disable them
            formatters = {
              json = "jq",
              html = function(body)
                return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
              end,
            },
          },
          -- Jump to request line on run
          jump_to_request = false,
          env_file = ".env",
          custom_dynamic_variables = {},
          yank_dry_run = true,
        })
      end,
      keys = {
        {
          "<leader>cq",
          function()
            require("rest-nvim").run(true)
          end,
          desc = "Preview Request",
          ft = "http",
        },
        {
          "<leader>ct",
          function()
            require("rest-nvim").run()
          end,
          desc = "Test Request",
          ft = "http",
        },
      },
    },

    {
      "pwntester/codeql.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "telescope.nvim",
        "nvim-tree/nvim-web-devicons",
        {
          "s1n7ax/nvim-window-picker",
          version = "v1.*",
          opts = {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              bo = {
                filetype = {
                  "codeql_panel",
                  "codeql_explorer",
                  "qf",
                  "TelescopePrompt",
                  "TelescopeResults",
                  "notify",
                  "NvimTree",
                  "neo-tree",
                },
                buftype = { "terminal" },
              },
            },
            current_win_hl_color = "#e35e4f",
            other_win_hl_color = "#44cc41",
          },
        },
      },
      opts = {
        additional_packs = {
          "/opt/codeql",
        },
      },
      cmd = { "QL" },
    },

    {
      "andymass/vim-matchup",
      event = "BufReadPost",
      init = function()
        vim.o.mps = vim.o.mps .. ',<:>,":"'
      end,
      config = function()
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
      end,
    },
  }
