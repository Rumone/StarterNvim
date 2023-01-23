local M = {}

M.configure = function()
	local null_ls = require("null-ls")
	local lsp = require("lsp-zero")
	local null_opts = lsp.build_options("null-ls", {})

	local formatters = null_ls.builtins.formatting
	local diagnostics = null_ls.builtins.diagnostics
	local completion = null_ls.builtins.completion

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	null_ls.setup({
		on_attach = function(client, bufnr)
			null_opts.on_attach(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnf = bufnr })
					end,
				})
			end
		end,

		sources = {},
	})

	require("mason-null-ls").setup({
		-- ensure_installed = {
		-- 	"prettier",
		-- 	"cspell",
		-- 	"stylua"
		-- },
		ensure_installed = nil,
		automatic_installtion = true,
		automatic_setup = false,
	})

	vim.diagnostic.config({
		virtual_text = true,
	})
end

return M
