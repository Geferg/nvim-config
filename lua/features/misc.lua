local M = {}

function M.conditional_dash()
  local ft = vim.bo.filetype
  if ft == "neo-tree" or ft == "NvimTree" then
    require("features.files").go_up_dir_in_place()
  else
    -- fallback to default behavior: move up a line and to first non-blank char
    vim.cmd("normal! -")
  end
end

return M
