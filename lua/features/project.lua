local M = {}

local project_root = nil

function M.set_project_dir()
  local path = nil

  -- Case 1: Inside Neo-tree
  local winid = vim.api.nvim_get_current_win()
  local buftype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(winid), "filetype")
  if buftype == "neo-tree" then
    local state = require("neo-tree.sources.manager").get_state("filesystem")
    local node = state.tree:get_node()
    if not node then
      vim.notify("No node selected in Neo-tree", vim.log.levels.WARN)
      return
    end
    path = node:get_id()
  else
    -- Case 2: Normal buffer
    local buf = vim.api.nvim_buf_get_name(0)
    if buf == "" then
      vim.notify("No file open to derive project root", vim.log.levels.WARN)
      return
    end
    path = buf
  end

  if vim.fn.isdirectory(path) == 0 then
    path = vim.fn.fnamemodify(path, ":p:h")
  end

  project_root = path
  vim.fn.chdir(project_root)
  vim.notify("Project root set to:\n" .. project_root, vim.log.levels.INFO)
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

function M.set_neotree_root_from_cursor()
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  local node = state.tree:get_node()
  local path = node:get_id()

  if vim.fn.isdirectory(path) == 0 then
    path = vim.fn.fnamemodify(path, ":p:h")
  end

  require("neo-tree.sources.filesystem").navigate(state, path, nil, nil)
  vim.notify("Neo-tree root set to:\n" .. path, vim.log.levels.INFO)
end

return M
