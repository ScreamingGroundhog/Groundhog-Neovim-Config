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
		local map = require("mason-lspconfig").get_mappings()
		local registry = require("mason-registry")

		-- Get the list of lsp
		local wanted = {}
		local config_path = vim.fn.stdpath("config")
		local lsp_files = vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)
		for _, filepath in ipairs(lsp_files) do
			-- Extract lsp name from path
			if filepath:find(config_path, 1, true) == 1 then
				local server_name = vim.fn.fnamemodify(filepath, ":t:r")
				if server_name and server_name ~= "" then
					wanted[server_name] = filepath
				end
			end
		end

		-- Clean
		registry.refresh(function()
			local packages = registry.get_installed_package_names()
			for _, pkg_name in ipairs(packages) do
				local server_name = map.package_to_lspconfig[pkg_name]
				if server_name and not wanted[server_name] then
					-- Uninstall no-need server
					registry.get_package(server_name):uninstall()
				end
			end
		end)

		-- Install
		for server_name, _ in pairs(wanted) do
			local success, pkg = pcall(registry.get_package, map.lspconfig_to_package[server_name])
			if success and not pkg:is_installed() then
				pkg:install()
			end
			vim.lsp.config(server_name, require("lsp." .. server_name))
			vim.lsp.enable(server_name, true)
		end

		vim.diagnostic.config({
			virtual_text = true,
			update_in_insert = true,
		})
	end,
}
