return {
    {
        "williamboman/mason.nvim",
        --cmd = "Mason",
        build = ":MasonUpdate",
        event = "VeryLazy",

        -- WARNING: Uses bad lazy spec
        config = function()
            require("mason").setup()

            local mason_registry = require("mason-registry")
            local servers = {
                "lua-language-server",
                "rust-analyzer",
                "pyright",
                "vscode-json-language-server",
                "cmake-language-server",
                "bash-language-server",
                "clangd",
            }

            for _, name in ipairs(servers) do
                local ok, pkg = pcall(mason_registry.get_package, name)
                if ok and not pkg:is_installed() then
                    pkg:install()
                end
            end
        end,
    },
}
