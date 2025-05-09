return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {}, -- Required to suppress Lazy's warning if using `config`
    config = function()
        local wk = require("which-key")
        local project = require("features.project")
        local files = require("features.files")

        wk.register({
            -- Group headings
            ["<leader>p"] = {
                name = "Project",
                v = { project.view_project_dir, "View project directory" },
                s = { project.set_project_dir, "Set project directory" },
            },

            ["<leader>f"] = { name = "Files" },
            ["<leader>d"] = { name = "Directory" },
            ["<leader>g"] = { name = "Git" },
            ["<leader>l"] = { name = "LSP" },
            ["<leader>b"] = { name = "Build" },
            ["<leader>s"] = { name = "Splits" },
            ["<leader>w"] = { name = "Window" },
            ["<leader>t"] = { name = "Tools" },

            ["<leader>fe"] = { vim.cmd.Ex, "Close file" },

        }, { mode = "n" })
    end,
}


