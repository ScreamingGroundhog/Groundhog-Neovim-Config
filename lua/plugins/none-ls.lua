-- =============================================================================
-- none-ls 插件配置
-- =============================================================================
-- none-ls 是 null-ls 的社区维护分支，用于将 linter / formatter / code action
-- 这类不依赖 LSP server 的外部工具桥接到 Neovim 内置的 LSP 客户端中。
-- 这样一来，通过 Mason 安装的命令行工具就能直接作为 formatter 被 `vim.lsp.buf.format()` 调用。
--
-- 声明式管理：
--   - 每个 formatter 的配置独立放在 lua/format/<name>.lua
--   - 添加 / 删除 formatter 只需创建 / 删除对应文件，无需修改本文件
--   - 首次加载时，Mason 会自动安装缺失的工具
-- =============================================================================

return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" }, -- none-ls 依赖 plenary 做异步任务
	event = "VeryLazy", -- 延迟加载，加快启动速度

	config = function()
		-- Mason 用来管理外部二进制工具（formatter、linter 等）的安装与升级
		local registry = require("mason-registry")
		-- none-ls 的 Lua 入口模块，名称保持 "null-ls" 以兼容原版生态
		local null_ls = require("null-ls")

		-- ---------------------------------------------------------------
		-- 通过 Mason 安装指定的包（如果尚未安装）
		-- @param name: Mason 包名，例如 "stylua"、"clang-format"
		--   Mason 包名 ≠ 可执行文件名，Mason 有自己的命名规范
		--   https://mason-registry.dev/ 可查询所有包的准确名称
		-- ---------------------------------------------------------------
		local function install(name)
			-- pcall 防止包名不存在时直接报错
			local ok, pkg = pcall(registry.get_package, name)
			if ok and not pkg:is_installed() then
				pkg:install() -- 异步安装，不会阻塞 UI
			end
		end

		-- ---------------------------------------------------------------
		-- 扫描 lua/format/*.lua 并构造 none-ls source 列表
		-- ---------------------------------------------------------------
		local sources = {}

		-- vim.fn.glob 用通配符匹配文件，返回匹配到的路径列表
		--   false → 不忽略隐藏文件
		--   true  → 只返回文件，不返回目录
		local glob = vim.fn.glob(vim.fn.stdpath("config") .. "/lua/format/*.lua", false, true)

		for _, filepath in ipairs(glob) do
			-- 从文件路径提取 Lua 模块名
			--   例: /home/user/.config/nvim/lua/format/stylua.lua → "format.stylua"
			local module_name = "format." .. vim.fn.fnamemodify(filepath, ":t:r")

			-- 加载 formatter 配置模块，获取 spec 表
			--   spec 结构: { name = "mason包名", builtin = none-ls内置源, override = { 可选覆盖参数 } }
			local spec = require(module_name)

			-- 只处理包含 builtin 的有效 spec
			if spec and spec.builtin then
				-- 1) 确保 Mason 已安装该工具
				install(spec.name)

				-- 2) 将 builtin 注册到 none-ls 的 source 列表中
				--    如果提供了 override 非空表，用 .with() 方法覆盖默认配置
				--    .with() 是 none-ls builtin 的内置方法，返回一个带有自定义参数的新 source
				if spec.override and type(spec.override) == "table" and vim.tbl_count(spec.override) > 0 then
					table.insert(sources, spec.builtin.with(spec.override))
				else
					-- 没有自定义参数，直接使用 builtin 的默认配置
					table.insert(sources, spec.builtin)
				end
			end
		end

		-- 将所有收集到的 source 注册到 none-ls
		-- 此后 vim.lsp.buf.format() 就能调用这些 formatter 了
		null_ls.setup({ sources = sources })
	end,

	-- =========================================================================
	-- 快捷键
	-- =========================================================================
	keys = {
		{
			"<leader>f",
			function()
				-- 调用 Neovim 内置的 LSP 格式化 API
				-- none-ls 注册的 source 会被当作 LSP formatter 被统一调度
				vim.lsp.buf.format()
			end,
			mode = { "n", "v" }, -- 普通模式 + 可视模式
			desc = "Format buffer/selection",
		},
	},
}
