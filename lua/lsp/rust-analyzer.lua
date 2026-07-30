return {
	filetypes = { "rust" },
	cmd = {
		"rust-analyzer",
	},
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true, -- 启用所有 features
				loadOutDirsFromCheck = true, -- 从 cargo check 加载输出目录
			},
			checkOnSave = {
				command = "clippy", -- 保存时使用 clippy 进行检查
			},
			procMacro = {
				enable = true, -- 启用 proc macro 支持
			},
		},
	},
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
}
