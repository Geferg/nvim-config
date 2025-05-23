return {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false, -- load at startup
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "Tmux Left" },
            { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "Tmux Down" },
            { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "Tmux Up" },
            { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Tmux Right" },
        },
    },
}
