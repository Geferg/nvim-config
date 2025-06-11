local M = {}

function M.is_windows()
    -- On Windows the path separator is backslash
    return package.config:sub(1, 1) == '\\'
end

function M.is_wsl()
    -- Fast-path via env vars set by every WSL version
    if os.getenv "WSL_DISTRO_NAME" or os.getenv "WSL_INTEROP" then
        return true
    end

    -- Heuristic: look for "Microsoft" in the kernel release string
    local f = io.popen("uname -r 2>/dev/null")
    local rel = f and f:read("*l") or ""
    if f then f:close() end
    return rel:find "[Mm]icrosoft" ~= nil
end

function M.is_linux()
    local f = io.popen("uname 2>/dev/null")
    local name = f and f:read("*l") or ""
    if f then f:close() end
    return name == "Linux"
end

function M.notify_os()
    if M.is_windows() then
        vim.notify("Windows detected", vim.log.levels.INFO)
    end

    if M.is_wsl() then
        vim.notify("WSL detected", vim.log.levels.INFO)
    end

    if M.is_linux() then
        vim.notify("Linux detected", vim.log.levels.INFO)
    end
end

return M
