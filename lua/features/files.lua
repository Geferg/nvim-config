local M = {}

-- Dependencies
local neo_cmd = require("neo-tree.command")
local fs_mgr = require("neo-tree.sources.manager")
local fs_src = require("neo-tree.sources.filesystem")
local uv = vim.loop

--- Open neo-tree at `dir`, replacing netrw-style behavior.
function M.open_dir(dir, opts)
    opts = vim.tbl_extend("force", { action = "show", position = "left", source = "filesystem" }, opts or {})
    -- Close existing tree then show new
    neo_cmd.execute({ action = "close" })
    neo_cmd.execute(vim.tbl_extend("force", opts, { dir = dir }))
end

--- Explore parent directory of current buffer's file.
function M.explore_parent()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
        vim.notify("No file open", vim.log.levels.WARN)
        return
    end
    local parent = vim.fn.fnamemodify(path, ":h")
    M.open_dir(parent, { position = "current" })
end

--- Toggle focus between last file and neo-tree buffer.
--NOTE: This stops all autocommands from firing on neotree focus via this function!!!!!
function M.toggle_focus()
    local ft = vim.bo.filetype

    if ft == "neo-tree" then
        vim.cmd("noautocmd wincmd p")
    else
        vim.cmd("Neotree focus")
    end
end

--- Go up one directory in place within neo-tree.
function M.up_one()
    local dir = vim.fn.expand("%:p:h")
    local parent = vim.fn.fnamemodify(dir, ":h")
    neo_cmd.execute({ dir = parent, position = "current", source = "filesystem", action = "show" })
end

--- Set neo-tree root and navigate to selected node under cursor.
function M.set_root_from_cursor()
    local state = fs_mgr.get_state("filesystem")
    local node = state.tree:get_node()
    if not node then
        vim.notify("No node selected in Neo-tree", vim.log.levels.WARN)
        return
    end
    local path = node:get_id()
    if vim.fn.isdirectory(path) == 0 then
        path = vim.fn.fnamemodify(path, ":p:h")
    end
    fs_src.navigate(state, path)
    vim.notify("Neo-tree root set to: " .. path, vim.log.levels.INFO)
end

--- Set Vim's working directory from cursor or current buffer.
function M.set_cwd_from_cursor()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    local path
    if ft == "neo-tree" then
        local state = fs_mgr.get_state("filesystem")
        local node = state.tree:get_node()
        if not node then
            vim.notify("No node selected in Neo-tree", vim.log.levels.WARN)
            return
        end
        path = node:get_id()
    else
        path = vim.api.nvim_buf_get_name(buf)
        if path == "" then
            vim.notify("No file to derive CWD from", vim.log.levels.WARN)
            return
        end
    end
    if vim.fn.isdirectory(path) == 0 then
        path = vim.fn.fnamemodify(path, ":p:h")
    end
    vim.fn.chdir(path)
    vim.notify("Working directory set to: " .. path, vim.log.levels.INFO)
end

--- Notify current working directory.
function M.echo_cwd()
    vim.notify(vim.fn.getcwd(), vim.log.levels.INFO)
end

--- List files in `dir`, filter by extension and include_ext flag.
function M.list_files(dir, extension, include_ext)
    include_ext = include_ext ~= false
    local ext
    if extension and extension ~= '' then
        ext = extension:match('^%.') and extension or ('.' .. extension)
    end

    local results = {}
    local it, err = uv.fs_scandir(dir)
    if not it then
        error(string.format("Failed to open directory '%s': %s", dir, err))
    end

    while true do
        local name, t = uv.fs_scandir_next(it)
        if not name then break end
        if t == 'file' and (not ext or name:sub(- #ext) == ext) then
            local out = include_ext or not ext
                and name or name:sub(1, #name - #ext)
            table.insert(results, out)
        end
    end
    return results
end

--- Return directory of calling file, up `levels` levels.
function M.this_dir(levels)
    levels = tonumber(levels) or 0
    local src = debug.getinfo(2, 'S').source:sub(2)
    local sep = package.config:sub(1, 1)
    local parts = vim.split(src, sep)
    local idx = math.max(1, #parts - levels)
    local root = table.concat(vim.list_slice(parts, 1, idx), sep)
    if src:sub(1, 1) == sep then root = sep .. root end
    if levels > 0 then root = root .. sep end
    return root
end

-- Backwards compatibility
function M.toggle_neotree_focus()
    vim.notify("`toggle_neotree_focus` is deprecated, use `toggle_focus`", vim.log.levels.WARN)
    return M.toggle_focus()
end

function M.go_up_dir_in_place()
    vim.notify("`go_up_dir_in_place` is deprecated, use `up_one`", vim.log.levels.WARN)
    return M.up_one()
end

function M.netrw_style_open(dir)
    vim.notify("`netrw_style_open` is deprecated, use `open_dir`", vim.log.levels.WARN)
    return M.open_dir(dir)
end

function M.set_neotree_root_from_cursor()
    vim.notify("`set_neotree_root_from_cursor` is deprecated, use `set_root_from_cursor`", vim.log.levels.WARN)
    return M.set_root_from_cursor()
end

M.format_on_save = true

function M.toggle_format_on_save()
    M.format_on_save = not M.format_on_save

    if M.format_on_save then
        print("format on save enabled")
    else
        print("format on save disabled")
    end
end

return M
