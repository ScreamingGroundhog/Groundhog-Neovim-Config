return {
    "nvimdev/lspsaga.nvim",
    cmd = "Lspsaga",
    opts = {
        finder = {
            keys = {
                toggle_or_open = "<CR>"
            }
        }
    },
    keys = {
        { "<leader>tr", ":Lspsaga rename<CR>" },
        { "<leader>tc", ":Lspsaga code_action<CR>" },
        { "<leader>td", ":Lspsaga definition<CR>" },
        { "<leader>td", ":Lspsaga hover_doc<CR>" },
        { "<leader>tR", ":Lspsaga finder<CR>" },
        { "<leader>tn", ":Lspsaga diagnostic_jump_next<CR>" },
        { "<leader>tp", ":Lspsaga diagnostic_jump_prev<CR>" },
    }
}
