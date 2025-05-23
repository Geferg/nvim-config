local M = {}

function M.conditional_dash()
    local ft = vim.bo.filetype
    if ft == "neo-tree" or ft == "NvimTree" then
        require("features.files").go_up_dir_in_place()
    else
        -- fallback to default behavior: move up a line and to first non-blank char
        local count = vim.v.count > 0 and tostring(vim.v.count) or ""
        vim.cmd("normal! " .. count .. "-")
    end
end

return M
