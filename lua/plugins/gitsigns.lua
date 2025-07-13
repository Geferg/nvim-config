return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local misc = require("features.misc")
            require("gitsigns").setup {
                signcolumn    = true,
                sign_priority = 130,
                signs         = {
                    add    = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr' },
                    change = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr' },
                    delete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr' },
                },
                on_attach     = function(bufnr)
                    -- mark this buffer as having gitsigns
                    vim.b[bufnr].gitsigns_attached = true
                    -- recalc now that gitsigns is up
                    misc.update_signcolumn(bufnr)
                end,
            }
        end,
    },
}
