return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
        local wk = require("which-key")
        local project = require("features.project")
        local files = require("features.files")

        wk.register({
            ["<leader>p"] = {
                name = "Project",

                s = { project.set_project_dir, "Set project directory" },
                v = { project.view_project_dir, "View project (sidebar)", },
            },

            ["<leader>f"] = {
                name = "Files",
                t = { "<cmd>Neotree toggle<CR>", "Toggle sidebar tree" },
                f = { files.toggle_neotree_focus, "Focus sidebar tree" },
                e = { files.explore_parent, "Explore parent dir" },

            },

            ["-"] = { files.go_up_dir_in_place, "Go up directory" },

            ["<leader>d"] = { name = "Directory" },
            ["<leader>g"] = { name = "Git" },
            ["<leader>l"] = { name = "LSP" },
            ["<leader>b"] = { name = "Build" },
            ["<leader>s"] = { name = "Splits" },
            ["<leader>w"] = { name = "Window" },
            ["<leader>t"] = { name = "Tools" },


        }, { mode = "n" })
    end,
}


