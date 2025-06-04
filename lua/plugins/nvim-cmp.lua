return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },

        config = function()
            local cmp = require("cmp")

            cmp.setup({

                mapping = cmp.mapping.preset.insert({
                    -- Navigate completion menu
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

                    -- Confirm selection
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),

                    -- Manually trigger completion
                    ["<C-Space>"] = cmp.mapping.complete(),

                    -- Abort completion
                    ["<C-e>"] = cmp.mapping.abort(),

                    -- Scroll documentation window
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),

                    -- Optional: smarter tab completion
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn == 1 then
                            feedkey("<Plug>(vsnip-expand-or-jump)", "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            feedkey("<Plug>(vsnip-jump-prev)", "")
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),

                experimental = {
                    ghost_text = true,
                },

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end
    }
}
