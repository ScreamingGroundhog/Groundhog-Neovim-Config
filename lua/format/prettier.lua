return {
    name = "prettier",
    builtin = require("null-ls").builtins.formatting.prettier,
    override = {
        formatters_by_ft = {
            javascript = {
                "prettier"
            },
            javascriptreact = {
                "prettier"
            }
        }
    }
}
