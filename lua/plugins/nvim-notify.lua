return {
	"rcarriga/nvim-notify",
    opts = {
        background_colour = function()
            return vim.fn.synIDattr(vim.fn.hllID("Normal"), "bg")
        end
    },
    config = function(_, opts)
       require("notify").setup(opts)
    end
}
