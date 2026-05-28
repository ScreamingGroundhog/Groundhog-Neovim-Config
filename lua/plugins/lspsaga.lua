-- LSP 增强 UI：提供美化版的 rename / code_action / definition / hover 等浮动窗口
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
        { "<leader>tr", ":Lspsaga rename<CR>",       desc = "Lspsaga: Rename" },
        { "<leader>tc", ":Lspsaga code_action<CR>",   desc = "Lspsaga: Code Action" },
        { "<leader>td", ":Lspsaga definition<CR>",    desc = "Lspsaga: Definition" },
        { "<leader>th", ":Lspsaga hover_doc<CR>",     desc = "Lspsaga: Hover Doc" },
        { "<leader>tR", ":Lspsaga finder<CR>",        desc = "Lspsaga: Finder" },
        { "<leader>tn", ":Lspsaga diagnostic_jump_next<CR>", desc = "Lspsaga: Next Diagnostic" },
        { "<leader>tp", ":Lspsaga diagnostic_jump_prev<CR>", desc = "Lspsaga: Prev Diagnostic" },
    }
}
