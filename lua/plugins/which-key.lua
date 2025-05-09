return {
    "folke/which-key.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
        triggers_nowait = {
            "<leader>",
        },

        disable = {
            buftypes = {},
            filetypes = {},
        },
    },
    config = function()
        local wk = require("which-key")
        local project = require("features.project")
        local files = require("features.files")

        wk.register({
            p = {
                name = "Project",

                s = { project.set_project_dir, "Set project directory" },
                v = { project.view_project_dir, "View project (sidebar)", },
            },

            f = {
                name = "Files",
                t = { "<cmd>Neotree toggle<CR>", "Toggle sidebar tree" },
                f = { files.toggle_neotree_focus, "Focus sidebar tree" },
                e = { files.explore_parent, "Explore parent dir" },

            },

            d = { name = "Directory" },
            g = { name = "Git" },
            l = { name = "LSP" },
            b = { name = "Build" },
            s = { name = "Splits" },
            w = { name = "Window" },
            t = { name = "Tools" },


        }, { mode = "n", prefix = "<leader>" })

        wk.register({
            ["-"] = { files.go_up_dir_in_place, "Go up directory" },
        }, { mode = "n", prefix = ""})
    end,
}


