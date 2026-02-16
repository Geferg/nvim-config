require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"pyright",
		"cmake",
		"bashls",
		"clangd",
		"html",
		"cssls",
		"jsonls",
		"eslint",
		"tailwindcss",
		"ts_ls",
	},
	automatic_enable = true, -- default, but explicit never hurts
})

local caps = vim.lsp.protocol.make_client_capabilities()
local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
	caps = cmp.default_capabilities(caps)
end

local function on_attach(_, bufnr)
	-- example keymap
	-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
end

vim.lsp.config("*", {
	capabilities = caps,
	on_attach = on_attach,
})
