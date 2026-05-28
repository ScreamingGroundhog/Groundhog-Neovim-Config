return {
    "AvengeMedia/base46",
    opts = {
        integrations = {
        },
        transparency = true
    },
    config = function(_, opts)
        require("base46").setup(opts)
        vim.cmd.colorscheme("dms")
    end
}
