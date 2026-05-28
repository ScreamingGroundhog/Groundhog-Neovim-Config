return {
	cmd = {
		"clangd",
		"--background-index", -- 后台自动建立索引
		"--clang-tidy", -- 启用 clang-tidy 静态检查
		"--header-insertion=iwyu", -- 自动插入缺少的头文件 (Include What You Use)
		"--completion-style=detailed", -- 补全时显示详细信息
		"--function-arg-placeholders", -- 补全函数时生成占位符
		"--fallback-style=llvm", -- 找不到 .clang-format 时默认使用的格式化风格
		"-j=4", -- 同时开启的 worker 数量
	},
	-- 解决 clangd 和其它 LSP 在 encoding 上的冲突（常见于 utf-16 报错）
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
}
