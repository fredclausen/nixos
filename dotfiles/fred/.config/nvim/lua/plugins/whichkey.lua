return {
    -- Modify which-key keys
    {
      "folke/which-key.nvim",
      opts = function()
        require("which-key").add({
          { "<leader>gb", group = "blame" },
          { "<leader>gd", group = "diffview" },
          { "<leader>h", group = "harpoon" },
          { "<leader>r", group = "run" },
          { "<leader>t", group = "test" },
        })
      end,
    },
  }
