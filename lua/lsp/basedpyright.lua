return {
	filetypes = { "python" },
	cmd = { "basedpyright-langserver", "--stdio" },
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "basic", -- basic / standard / strict
				autoImportCompletions = true, -- 自动导入补全
				autoSearchPaths = true, -- 自动搜索虚拟环境
				useLibraryCodeForTypes = true,
			},
		},
	},
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
}
