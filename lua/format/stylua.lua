-- =============================================================================
-- stylua formatter 配置
-- =============================================================================
-- stylua 是一个专为 Lua 设计的 opinionated formatter。
-- 默认设置已经足够好，因此不提供 override，直接使用 builtin 默认值。

return {
	-- Mason 包名 — 用于自动安装/下载 stylua 可执行文件
	-- 注意：Mason 中包名通常与工具名一致，但并非绝对
	-- 可执行 `:Mason` 或访问 https://mason-registry.dev/ 查询
	name = "stylua",

	-- none-ls 内置的 stylua 格式化源
	--   null_ls.builtins.formatting 下包含了各种 formatter 的预定义配置
	--   这些预定义配置包括了：默认命令行参数、文件类型过滤、环境变量等
	builtin = require("null-ls").builtins.formatting.stylua,

	-- 未提供 override → 使用 stylua 默认参数（等价于直接调用 `stylua -`）
}
