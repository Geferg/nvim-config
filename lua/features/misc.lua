local M = {}

function M.conditional_dash()
    local ft = vim.bo.filetype
    if ft == "neo-tree" or ft == "NvimTree" then
        require("features.files").up_one()
    else
        -- fallback to default behavior: move up a line and to first non-blank char
        local count = vim.v.count > 0 and tostring(vim.v.count) or ""
        vim.cmd("normal! " .. count .. "-")
    end
end

local ignore_buftypes = { nofile = true, prompt = true, popup = true }
local ignore_filetypes = { ['neo-tree'] = true }

function M.update_signcolumn(bufnr, winnr)
    bufnr       = bufnr or vim.api.nvim_get_current_buf()
    winnr       = winnr or vim.api.nvim_get_current_win()

    -- fetch buffer options
    local bopts = vim.bo[bufnr]

    -- if this buffer/filetype should be ignored, do nothing
    if ignore_buftypes[bopts.buftype] or ignore_filetypes[bopts.filetype] then
        -- print("ignored buff " .. bopts.buftype .. " | " .. bopts.filetype)
        return
    end

    -- print("changed buff " .. bopts.buftype .. " | " .. bopts.filetype)

    -- count the things that want the signcolumn
    local cols = 0

    -- 1) any LSP clients attached?
    if next(vim.lsp.get_clients({ bufnr = bufnr })) then
        cols = cols + 1
    end

    -- 2) gitsigns attached?
    if vim.b[bufnr].gitsigns_attached then
        cols = cols + 1
    end

    -- set signcolumn: "no" when zero, or "yes:<n>" otherwise
    local val = (cols == 0 and "no") or ("yes:" .. cols)
    vim.api.nvim_win_set_option(winnr, "signcolumn", val)
end

return M
