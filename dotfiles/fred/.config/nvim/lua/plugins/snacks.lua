return  {
    {
        "folke/snacks.nvim",
        opts = {
            picker =  {
                hidden = true,
            },
            lazygit = {
                enabled = true,
            }
        },
        keys = {
            { "<leader>zz", function() Snacks.lazygit() end, desc = "Lazygit Log (cwd)" },
        }
    }
}
