return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- Default capabilities with cmp (optional)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local lspconfig = require("lspconfig")
            local lsp = require("features.lsp")

            -- Common on_attach function
            local on_attach = function(client, bufnr)
                -- Enable inlay hints if supported
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end
            end

            for name, opts in pairs(lsp.servers) do
                lspconfig[name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = opts,
                }
            end
        end,
    },
}
