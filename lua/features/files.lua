local M = {}

function M.exit_file()
  vim.cmd.bdelete()
end

return M
