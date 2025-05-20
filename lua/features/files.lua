local M = {}

local neotree = require("neo-tree.command")

function M.netrw_style_open(dir)
  neotree.execute({ action = "close", position = "left" })
  neotree.execute({
    source = "filesystem",
    action = "show",
    dir = dir,
    position = "current",
  })
end

function M.explore_parent()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("No file open", vim.log.levels.WARN)
    return
  end
  local parent = vim.fn.fnamemodify(path, ":h")
  M.netrw_style_open(parent)
end

function M.toggle_neotree_focus()
  local ft = vim.bo.filetype
  local bufnr = vim.g.last_file_bufnr
  if ft == "neo-tree" and bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_set_current_buf(bufnr)
  else
    vim.cmd("Neotree focus")
  end
end

function M.go_up_dir_in_place()
  local current_dir = vim.fn.expand("%:p:h") -- current dir
  local parent = vim.fn.fnamemodify(current_dir, ":h")

  require("neo-tree.command").execute({
    dir = parent,
    position = "current",
    source = "filesystem",
    action = "show",
  })
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

function M.set_cwd_from_cursor()
  local path

  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")

  if filetype == "neo-tree" then
    local state = require("neo-tree.sources.manager").get_state("filesystem")
    local node = state.tree:get_node()
    if not node then
      vim.notify("No node selected in Neo-tree", vim.log.levels.WARN)
      return
    end
    path = node:get_id()
  else
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname == "" then
      vim.notify("No file to derive CWD from", vim.log.levels.WARN)
      return
    end
    path = bufname
  end

  if vim.fn.isdirectory(path) == 0 then
    path = vim.fn.fnamemodify(path, ":p:h")
  end

  vim.fn.chdir(path)
  vim.notify("Working directory set to:\n" .. path, vim.log.levels.INFO)
end

function M.echo_cwd()
  local cwd = vim.fn.getcwd()
  vim.notify("Current working directory:\n" .. cwd, vim.log.levels.INFO)
end

return M
