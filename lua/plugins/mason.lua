-- 声明式 LSP 管理：
--   将 LSP 配置放在 lua/lsp/<name>.lua，mason 自动安装并启用
--   删除文件后下次启动自动卸载对应 LSP
return {
	"mason-org/mason.nvim",
	event = "VeryLazy",
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function(_, opts)
		require("mason").setup(opts)

		local mappings = require("mason-lspconfig").get_mappings()
		local registry = require("mason-registry")

		-- 扫描 lua/lsp/*.lua 获取需要启用的 LSP server 列表
		local wanted = {}
		local glob = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/lsp/*.lua", false, true)
		for _, filepath in ipairs(glob) do
			local pkg_name = vim.fn.fnamemodify(filepath, ":t:r")
			if pkg_name and pkg_name ~= "" then
				wanted[pkg_name] = filepath
			end
		end

		-- 卸载不再需要的 LSP server（文件已被删除的）
		registry.refresh(function()
			local packages = registry.get_installed_package_names()
			for _, pkg_name in ipairs(packages) do
				if pkg_name and not wanted[pkg_name] then
					local pkg = registry.get_package(pkg_name)
					if pkg:is_installed() then
						pkg:uninstall()
					end
				end
			end
		end)

		-- 获取 blink.cmp 的 LSP 补全能力（防 blink 未加载时崩溃）
		local ok, blink_cap = pcall(function()
			return require("blink.cmp").get_lsp_capabilities()
		end)
		local capabilities = ok and blink_cap or {}

		-- 安装并配置所有声明的 LSP server
		for pkg_name, _ in pairs(wanted) do
			if pkg_name then
				local ok_pkg, _ = pcall(registry.get_package, pkg_name)
				if ok_pkg then
					local pkg = registry.get_package(pkg_name)
					if not pkg:is_installed() then
						pkg:install()
					end
				end
			end
			-- 读取 lua/lsp/<name>.lua 配置，合并 capabilities 后启用
			local lsp_config = require("lsp." .. pkg_name)
			lsp_config.capabilities = vim.tbl_deep_extend(
				"force",
				lsp_config.capabilities or {},
				capabilities
			)
            local server_name = mappings.package_to_lspconfig[pkg_name]
			vim.lsp.config(server_name, lsp_config)
			vim.lsp.enable(server_name, true)
		end

		-- LSP 快捷键（仅当前 buffer 生效）
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf
				local function map(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = buf, desc = "LSP: " .. desc })
				end

				map("gd", vim.lsp.buf.definition, "Goto Definition")
				map("gr", vim.lsp.buf.references, "Goto References")
				map("gi", vim.lsp.buf.implementation, "Goto Implementation")
				map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
				map("gD", vim.lsp.buf.declaration, "Goto Declaration")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("<leader>cr", vim.lsp.buf.rename, "Rename")
				map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
			end,
		})

		vim.diagnostic.config({
			virtual_text = true,
			update_in_insert = true,
		})
	end,
}
