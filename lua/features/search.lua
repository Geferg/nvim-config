local telescope = require("telescope.builtin")
local project = require("features.project")

local M = {}

-- Search current file for a string
function M.telescope_search_file()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("No file loaded", vim.log.levels.WARN)
        return
    end
    telescope.grep_string({
        search = vim.fn.input("Search in file: "),
        path_display = { "shorten" },
        only_sort_text = true,
        prompt_title = "Search in File",
        cwd = vim.fn.fnamemodify(file, ":h"),
    })
end

-- Project-wide search based on your project_root logic
function M.telescope_search_project()
    telescope.live_grep({
        cwd = project.project_root,
        prompt_title = "Live Grep (project)",
    })
end

-- Search in visual cwd context (typically for treeviews or open files)
function M.telescope_search_cwd()
    telescope.live_grep({
        cwd = vim.fn.getcwd(),
        prompt_title = "Live Grep (cwd)",
    })
end

-- Global search (system-wide) — limited by ripgrep permissions
function M.telescope_search_system()
    telescope.live_grep({
        cwd = "/",
        prompt_title = "Live Grep (system)",
        additional_args = { "--hidden", "--no-ignore" },
    })
end

return M
