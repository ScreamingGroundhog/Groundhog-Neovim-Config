-- =============================================================================
-- rustfmt formatter 配置
-- =============================================================================
-- rustfmt 是 Rust 官方提供的代码格式化工具。
-- 默认使用项目根目录的 rustfmt.toml 或 cargo fmt 配置。
-- 如果没有项目级配置，则使用 rustfmt 的默认风格。

return {
	-- Mason 包名 — 用于自动安装 rustfmt 二进制
	name = "rustfmt",

	-- none-ls 内置的 rustfmt 格式化源
	builtin = require("null-ls").builtins.formatting.rustfmt,

	-- override 会被传给 builtin.with()，覆盖内置源的默认配置
	override = {
		-- rustfmt 默认会向上查找项目根目录的 rustfmt.toml
		-- extra_args 可以添加额外参数，如 --edition 2021
		extra_args = {
			"--edition", "2021",
		},
	},
}
