local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"

vim.lsp.config.lua_ls = {
    cmd = { mason_path .. "lua-language-server" },
    filetypes = { 'lua' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

vim.lsp.enable({ 'lua_ls' })
