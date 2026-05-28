return {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    event = "VeryLazy",
    opts = {
        completion = {
            documentation = {
                auto_show = true
            }
        },
        keymap = {
            preset = "super-tab",
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" }
        },
        sources = {
            default = { "path", "snippets", "buffer", "lsp" }
        },
        cmdline = {
            sources = function()
                local cmd_type = vim.fn.getcmdtype()
                if cmd_type == "/" or cmd_type == "?" then
                    return { "buffer" }
                elseif cmd_type == ":" then
                    return { "cmdline" }
                else
                    return {}
                end
            end,
            keymap = {
                preset = "super-tab"
            },
            completion = {
                menu = {
                    auto_show = true
                }
            }
        },
        signature = { enabled = true }
    }
}
