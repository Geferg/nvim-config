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
        local misc = require("features.misc")

        wk.register({
            p = {
                name = "Project",

                s = { project.set_project_dir, "Set project directory" },
                v = { project.view_project_dir, "View project (sidebar)", },
                g = {
                    name = "Generate project",
                    r = { function() project.generate_project("rust") end, "Rust project" },
                    p = { function() project.generate_project("python") end, "Python project" },
                },
                b = { project.build_project, "Build project" },
                r = { project.run_project, "Run project" },
            },

            f = {
                name = "Files",

                t = { "<cmd>Neotree toggle<CR>", "Toggle sidebar tree" },
                f = { files.toggle_neotree_focus, "Focus sidebar tree" },
                e = { files.explore_parent, "Explore parent dir" },
                r = { files.set_neotree_root_from_cursor, "Reset tree root to cursor" },
                s = { files.set_cwd_from_cursor, "Set CWD from file or tree" },
                w = { files.echo_cwd, "Show working directory" },
            },

            t = {
                name = "Tools",
                h = { "<cmd>Hardtime toggle<CR>", "Toggle hardtime hints" },
                u = { "<cmd>UndotreeToggle<CR>", "Toggle undotree" },
            },

            v = {
                name = "View",
                t = { "<cmd>Twilight<CR>", "Toggle twilight view" },
            },

            d = { name = "Directory" },
            g = { name = "Git" },
            l = { name = "LSP" },
            b = { name = "Build" },
            s = { name = "Splits" },
            w = { name = "Window" },



        }, { mode = "n", prefix = "<leader>" })

        wk.register({
            ["-"] = { misc.conditional_dash, "Go up directory" },
        }, { mode = "n", prefix = ""})
    end,
}


