return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        opts = {
            close_if_last_window = true,
            enable_git_status    = true,
            enable_diagnostics   = true,

            --─── source-specific settings ──────────────────────────────────────
            filesystem           = {
                filtered_items = {
                    visible         = true,
                    hide_dotfiles   = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = true,
                },
                window = {
                    mappings = {
                        ["<space>"] = "none",
                    },
                },
                --hijack_netrw_behavior = "open_default",
            },

            buffers              = { window = { mappings = { ["<space>"] = "none" } } },
            git_status           = { window = { mappings = { ["<space>"] = "none" } } },
            document_symbols     = { window = { mappings = { ["<space>"] = "none" } } },

            --─── fallback / global window options ─────────────────────────────
            window               = {
                mappings = {
                    ["<space>"] = "none",
                },
            },

            disable              = {
                buftypes  = {},
                filetypes = {},
            },
        },
    },
}
