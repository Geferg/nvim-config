local M = {}

local project_root = nil

function M.set_project_dir()
  local buf = vim.api.nvim_buf_get_name(0)
  if buf == "" then
    vim.notify("No file open to derive project root", vim.log.levels.WARN)
    return
  end
  project_root = vim.fn.fnamemodify(buf, ":p:h")
  vim.notify("Project root set to " .. project_root, vim.log.levels.INFO)
end

function M.get_project_dir()
  return project_root
end

function M.view_project_dir()
  local root = M.get_project_dir()
  if root then
    require("neo-tree.command").execute({
      source = "filesystem",
      action = "show",
      dir = root,
      position = "left",
    })
  else
    vim.notify("Project directory not set", vim.log.levels.WARN)
  end
end

return M
