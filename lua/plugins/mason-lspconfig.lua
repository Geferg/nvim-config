return {
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            local lsp = require("features.lsp")
            require("mason-lspconfig").setup {
                ensure_installed = vim.tbl_keys(lsp.servers),
                automatic_installation = true,
            }
        end,
    },
}
