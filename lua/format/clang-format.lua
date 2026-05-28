-- =============================================================================
-- clang-format formatter 配置
-- =============================================================================
-- clang-format 是 LLVM 项目提供的 C / C++ / Java / JavaScript 等语言格式化工具。
-- 可通过命令行参数 --style 控制缩进风格，也支持 .clang-format 配置文件。
-- 本配置使用 4 格缩进，并以 Tab 替代空格（UseTab: Always）。

return {
	-- Mason 包名 — 用于自动安装 clang-format 二进制
	name = "clang-format",

	-- none-ls 内置的 clang-format 格式化源
	builtin = require("null-ls").builtins.formatting.clang_format,

	-- override 会被传给 builtin.with()，覆盖内置源的默认配置
	-- builtin.with() 返回一个**新** source，不会修改原始 builtin
	-- 具体可覆盖的字段取决于各个 builtin，常见的有：
	--   extra_args  — 追加命令行参数（table of strings）
	--   filetypes   — 限制生效的文件类型
	--   condition   — 条件函数，返回 true 时该 source 才生效
	--   args        — 完全替换命令行参数
	override = {
		extra_args = {
			-- --style 指定代码风格，这里用内联 JSON 格式（也可用 file:path 指向配置文件）
			"--style={ IndentWidth: 4, TabWidth: 4, UseTab: Always }",
		},
	},
}

-- 附：clang-format 默认会向上查找项目根目录的 .clang-format 文件
--     项目级 .clang-format 优先级 > extra_args 中的 --style
--     如果想完全忽略项目配置，可在 extra_args 中加入 "--style=file:/dev/null"
