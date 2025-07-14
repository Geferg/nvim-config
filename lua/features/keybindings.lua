local project = require("features.project")
local files = require("features.files")
local misc = require("features.misc")
local remap = require("features.remap")
local host = require("features.host")
local harpoon = require("harpoon")
local config = vim.fn.stdpath("config")

return {
    {
        ---------------------------------------------------------------
        -- Project
        ---------------------------------------------------------------
        { "<leader>p",     group = "Project" },
        { "<leader>pb",    project.build_project,                                                        desc = "build project" },
        { "<leader>pc",    project.clean_project,                                                        desc = "clean project" },
        { "<leader>pr",    project.run_project,                                                          desc = "run project" },
        { "<leader>ps",    project.set_project_dir,                                                      desc = "set project directory" },
        { "<leader>pv",    project.view_project_dir,                                                     desc = "view project (sidebar)" },

        { "<leader>pg",    group = "Generate project" },
        { "<leader>pgp",   function() project.generate_project("python") end,                            desc = "python project" },

        { "<leader>pgr",   group = "Rust" },
        { "<leader>pgrr",  function() project.generate_project("rust") end,                              desc = "basic" },
        { "<leader>pgrc",  group = "Ratatui console UI" },
        { "<leader>pgrcs", function() project.generate_project("ratatui") end,                           desc = "Simple template" },

        ---------------------------------------------------------------
        -- Git
        ---------------------------------------------------------------
        { "<leader>g",     group = "Git" },
        -- { "<leader>gd",    "<cmd><cr>",                                                                  desc = "Show git diff" },
        -- { "<leader>gs",    "<cmd><cr>",                                                                  desc = "Show git status" },
        { "<leader>gg",    "<cmd>Neogit<cr>",                                                            desc = "neogit core menu" },
        { "<leader>gw",    "<cmd>Gitsigns toggle_word_diff<cr>",                                         desc = "Toggle word diff" },
        { "<leader>gh",    "<cmd>Gitsigns stage_hunk<cr>",                                               desc = "Toggle hunk staging" },
        { "<leader>gp",    "<cmd>Gitsigns preview_hunk_inline<cr>",                                      desc = "" },
        { "<leader>gb",    "<cmd>Gitsigns blame_line<cr>",                                               desc = "Show blame" },

        ---------------------------------------------------------------
        -- Diagnostics (Trouble)
        ---------------------------------------------------------------
        { "<leader>d",     group = "Diagnostics" },
        { "<leader>dd",    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                           desc = "buffer diagnostics" },
        { "<leader>da",    "<cmd>Trouble diagnostics toggle<cr>",                                        desc = "all diagnostics" },
        { "<leader>dl",    "<cmd>Trouble loclist toggle<cr>",                                            desc = "location list" },
        { "<leader>dq",    "<cmd>Trouble qflist toggle<cr>",                                             desc = "quickfix list" },
        { "<leader>dr",    "<cmd>Trouble lsp toggle focus=false<cr>",                                    desc = "lsp refs/defs/etc." },
        { "<leader>ds",    "<cmd>Trouble symbols toggle focus=false<cr>",                                desc = "symbols" },

        ---------------------------------------------------------------
        -- Files
        ---------------------------------------------------------------
        { "<leader>f",     group = "Files" },
        { "<leader>fe",    files.explore_parent,                                                         desc = "explore parent dir" },
        { "<leader>ff",    files.toggle_focus,                                                           desc = "focus sidebar tree" },
        { "<leader>fr",    files.set_neotree_root_from_cursor,                                           desc = "reset tree root to cursor" },
        { "<leader>fs",    files.set_cwd_from_cursor,                                                    desc = "set cwd from file or tree" },
        { "<leader>fw",    files.echo_cwd,                                                               desc = "show working directory" },
        { "<leader>ft",    "<cmd>Neotree toggle<cr>",                                                    desc = "toggle sidebar tree" },

        ---------------------------------------------------------------
        -- Harpoon
        ---------------------------------------------------------------
        { "<leader>h",     group = "Harpoon" },
        { "<leader>ha",    function() harpoon:list():add() end,                                          desc = "Add file" },
        { "<leader>hm",    function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,                  desc = "Menu" },
        { "<leader>hh",    function() harpoon:list():select(1) end,                                      desc = "Jump to 1" },
        { "<leader>hj",    function() harpoon:list():select(2) end,                                      desc = "Jump to 2" },
        { "<leader>hk",    function() harpoon:list():select(3) end,                                      desc = "Jump to 3" },
        { "<leader>hl",    function() harpoon:list():select(4) end,                                      desc = "Jump to 4" },

        ---------------------------------------------------------------
        -- Tools
        ---------------------------------------------------------------
        { "<leader>t",     group = "Tools" },
        { "<leader>th",    "<cmd>Hardtime toggle<cr>",                                                   desc = "toggle hardtime hints" },
        { "<leader>tu",    "<cmd>UndotreeToggle<cr>",                                                    desc = "toggle undotree" },
        { "<leader>tc",    "<cmd>VimCoach<cr>",                                                          desc = "Vim cheat-sheet" },
        { "<leader>tj",    "<cmd>JsonGraphView<cr>",                                                     desc = "JSON visualizer" },
        { "<leader>tf",    files.toggle_format_on_save,                                                  desc = "toggle formatting on save" },

        { "<leader>tr",    group = "Remaps" },
        { "<leader>trd",   remap.disable,                                                                desc = "disable remaps at startup" },
        { "<leader>tre",   remap.enable,                                                                 desc = "enable remaps at startup" },
        { "<leader>trs",   remap.sync,                                                                   desc = "sync and reload remaps" },

        { "<leader>td",    group = "Debug config" },
        { "<leader>tdo",   host.notify_os,                                                               desc = "check host os" },
        { "<leader>tdx",   "<cmd>luafile " .. config .. "/misc/extmark-sniffer/extmark-sniffer.lua<CR>", desc = "get all extmarks" },

        ---------------------------------------------------------------
        -- View
        ---------------------------------------------------------------
        { "<leader>v",     group = "View" },
        { "<leader>vt",    "<cmd>Twilight<CR>",                                                          desc = "Toggle twilight view" },
        { "<leader>vc",    "<cmd>Themery<CR>",                                                           desc = "Select colorscheme" },

        ---------------------------------------------------------------
        -- FunBox
        ---------------------------------------------------------------
        { "<leader>b",     group = "funBox" },
        { "<leader>bt",    group = "Typr" },
        { "<leader>btt",   "<cmd>Typr<cr>",                                                              desc = "Typr test" },
        { "<leader>bts",   "<cmd>TyprStats<cr>",                                                         desc = "Typr stats" },
        { "<leader>bm",    "<cmd>Store<cr>",                                                             desc = "Plugin magazine" },

        ---------------------------------------------------------------
        -- Unused
        ---------------------------------------------------------------
        { "<leader>w",     group = "Window" },
        { "<leader>s",     group = "Splits" },

        ---------------------------------------------------------------
        -- Non-leader
        ---------------------------------------------------------------
        { "-",             misc.conditional_dash,                                                        desc = "go up directory" },
    }
}
