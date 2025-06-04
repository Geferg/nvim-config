local mason_path = vim.fn.stdpath("data") .. "/mason/bin/"
local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Lua
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

-- Rust
vim.lsp.config.rust_analyzer = {
    cmd = { mason_path .. "rust-analyzer" },
    filetypes = { "rust" },
    capabilities = capabilities,
}

-- Python
vim.lsp.config.pyright = {
    cmd = { mason_path .. "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    capabilities = capabilities,
}

-- JSON
vim.lsp.config.jsonls = {
    cmd = { mason_path .. "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    capabilities = capabilities,
}

-- CMake
vim.lsp.config.cmake = {
    cmd = { mason_path .. "cmake-language-server" },
    filetypes = { "cmake" },
    capabilities = capabilities,
}

-- Bash
vim.lsp.config.bashls = {
    cmd = { mason_path .. "bash-language-server", "start" },
    filetypes = { "sh" },
    capabilities = capabilities,
}

-- C/C++
vim.lsp.config.clangd = {
    cmd = { mason_path .. "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    capabilities = capabilities,
}

-- Enable all servers
vim.lsp.enable({
    "lua_ls",
    "rust_analyzer",
    "pyright",
    "jsonls",
    "cmake",
    "bashls",
    "clangd",
})
