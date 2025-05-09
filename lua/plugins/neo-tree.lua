return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
            filtered_items = {
                visible = true, -- show hidden files by default
                hide_dotfiles = false,
                hide_gitignored = false,
            },
        },
        window = {
            mappings = {
                ["<leader>"] = nil,
            },
        },
        disable = {
            buftypes = {},   -- allow "nofile"
            filetypes = {},  -- allow "neo-tree"
        },
    },
}
