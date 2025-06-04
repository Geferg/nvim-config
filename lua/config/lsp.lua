local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config.lua_ls = {
    cmd = { mason_path .. "lua-language-server" },
    filetypes = { 'lua' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
    capabilities = capabilities,
}

vim.lsp.enable({ 'lua_ls' })
