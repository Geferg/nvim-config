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
      ["<leader>f"] = { name = "Files" },
      ["<leader>p"] = { name = "Project" },

      -- Actual mappings
      ["<leader>fe"] = { files.exit_file, "Close file" },
      ["<leader>ps"] = { project.set_project_dir, "Set project directory" },
      ["<leader>pv"] = { project.view_project_dir, "View project directory" },
    }, { mode = "n" })
  end,
}

