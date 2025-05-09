local M = {}
local project_root = nil

-- Set current file's folder as project root
function M.set_project_dir()
    project_root = vim.fn.expand("%:p:h")
    vim.cmd.cd(project_root)
    print("Project directory set to: " .. project_root)
end

function M.view_project_dir()
    if project_root then
        vim.cmd.cd(project_root)
        vim.cmd.Ex()
    else
        vim.cmd.Ex()
        vim.notify("No project dir set — opened file's directory instead", vim.log.levels.WARN)
    end
end

return M
