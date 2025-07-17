return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        -- WARNING: Uses bad lazy spec
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    seciton_separators = "",
                    component_separators = "",
                },
            })
        end
    },
}
