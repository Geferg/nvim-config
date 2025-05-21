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
        local remap = require("features.remap")

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
                c = { project.clean_project, "Clean project" },
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
                r = {
                    name = "Remaps",

                    s = { remap.sync, "Sync and reload remaps" },
                    e = { remap.enable, "Enable remaps at startup" },
                    d = { remap.disable, "Disable remaps at startup" },
                }
            },

            v = {
                name = "View",

                t = { "<cmd>Twilight<CR>", "Toggle twilight view" },
            },

            d = {
                name = "Diagnostics",
                d = { "<cmd>Trouble diagnostics toggle<cr>", "All Diagnostics" },
                b = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics" },
                l = { "<cmd>Trouble loclist toggle<cr>", "Location List" },
                q = { "<cmd>Trouble qflist toggle<cr>", "Quickfix List" },
                s = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols" },
                r = { "<cmd>Trouble lsp toggle focus=false<cr>", "LSP Refs/Defs/etc." },
            },


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


