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

return M
