-------------------------------------------------------------------------------
-- Sync remap.ahk between WSL and Windows and (re)load AutoHotkey v2
-------------------------------------------------------------------------------

local M = {}

-- Abort on non-WSL systems
if not vim.loop.fs_stat("/proc/version") then
    return M -- not even Linux
end

local version_content = vim.fn.readfile("/proc/version")[1] or ""
if not version_content:match("Microsoft") and not version_content:match("WSL") then
    vim.notify("AHK sync disabled: not running in WSL", vim.log.levels.INFO)
    return M
end

---------------------------------------------------------------------
-- Paths (edit here if layout differs)
---------------------------------------------------------------------
local wsl_src     = vim.fn.expand("$HOME/.config/nvim/misc/remap.ahk")
local shared_base = "C:\\ProgramData\\nvim-config" -- one place for all users
local win_dest    = shared_base .. "\\remap.ahk"   -- active copy
local startup_lnk = shared_base .. "\\remap.lnk"   -- optional startup link

-- Hard require AutoHotkey v2 x64. Change to AutoHotkey32.exe on 32-bit systems.
local ahk_exe     = "C:\\Program Files\\AutoHotkey\\v2\\AutoHotkey64.exe"

---------------------------------------------------------------------
-- Utility helpers
---------------------------------------------------------------------
--- Run a PowerShell snippet, notify on error
local function ps(cmd)
    local out = vim.fn.system({ "powershell.exe", "-NoProfile", "-Command", cmd })
    local ok  = (vim.v.shell_error == 0)
    if not ok then
        vim.notify(("⚠️  PowerShell error (%d):\n%s")
            :format(vim.v.shell_error, out),
            vim.log.levels.ERROR)
    end
    return ok, out
end

--- Escape single quotes for PowerShell literals
local function sq(str)
    return str:gsub("'", "''")
end

--- Convert Windows path (C:\foo\bar) to WSL mount (/mnt/c/foo/bar)
local function to_wsl(path)
    return path
        :gsub("^([A-Za-z]):\\", "/mnt/%1/")
        :gsub("\\", "/")
        :lower()
end

---------------------------------------------------------------------
-- File operations
---------------------------------------------------------------------
--- Ensure the shared folder exists in Windows
local function ensure_dir()
    return ps(("New-Item -Path '%s' -ItemType Directory -Force")
        :format(sq(shared_base)))
end

--- Copy the AHK script from WSL into Windows ProgramData
local function copy_file()
    local dst = to_wsl(win_dest)
    vim.fn.system(string.format('cp "%s" "%s"', wsl_src, dst))
    if vim.v.shell_error ~= 0 then
        return false, "cp failed"
    end
    -- verify on the Windows side
    return ps(("Test-Path '%s'"):format(sq(win_dest)))
end

--- Copy the AHK script asynchronously and invoke a callback(on_success, msg)
local function copy_file_async(callback)
    local dst = to_wsl(win_dest)
    vim.fn.jobstart({ "cp", wsl_src, dst }, {
        on_exit = function(_, exit_code, _)
            if exit_code ~= 0 then
                return callback(false, "cp failed with exit code " .. exit_code)
            end
            -- Now verify on the Windows side via PowerShell
            local ok, out = ps(("Test-Path '%s'"):format(sq(win_dest)))
            if not ok then
                return callback(false, "Windows Test-Path failed:\n" .. out)
            end
            callback(true)
        end,
    })
end

---------------------------------------------------------------------
-- AutoHotkey control
---------------------------------------------------------------------
--- Kill any running AHK and start a fresh instance detached
local function restart_ahk()
    local cmd = ([[
    Stop-Process -Name AutoHotkey -ErrorAction SilentlyContinue
    Start-Process -FilePath '%s' -ArgumentList '/restart','%s'
    exit 0
    ]]):format(sq(ahk_exe), sq(win_dest))
    return ps(cmd)
end

---------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------
--- Copy script and reload AHK
function M.sync_old()
    if not ensure_dir() then
        return vim.notify("Failed to create " .. shared_base, vim.log.levels.ERROR)
    end
    local ok, msg = copy_file()
    if not ok then
        return vim.notify("Copy error: " .. msg, vim.log.levels.ERROR)
    end
    if not restart_ahk() then
        return vim.notify("Failed to restart AHK", vim.log.levels.ERROR)
    end
    vim.notify("🔁 AHK script synced and reloaded.", vim.log.levels.INFO)
end

function M.sync()
    if not ensure_dir() then
        return vim.notify("⚠️  Cannot create directory: " .. shared_base, vim.log.levels.ERROR)
    end

    -- async copy, then restart AHK on success
    copy_file_async(function(ok, err)
        if not ok then
            return vim.notify("⚠️  Copy failed: " .. (err or "unknown"), vim.log.levels.ERROR)
        end

        if not restart_ahk() then
            return vim.notify("⚠️  AutoHotkey restart failed", vim.log.levels.ERROR)
        end

        vim.notify("🔁  AHK script synced and reloaded.")
    end)
end

--- Enable AHK on system startup via HKLM Run key (with UAC prompt)
function M.enable()
    assert(ensure_dir(), "cannot create " .. shared_base)

    -- Build the raw PowerShell snippet we want to run elevated.
    local ps_script = ([[
    $Name  = 'RemapAHK'
    $Value = '%s /restart "%s"'
    New-ItemProperty `
    -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' `
    -Name $Name `
    -Value $Value `
    -PropertyType String `
    -Force
    ]]):format(sq(ahk_exe), sq(win_dest))

    -- Re-spawn PowerShell *elevated* just for that snippet:
    local elevate_cmd = {
        "powershell.exe",
        "-NoProfile",
        "-Command",
        ("Start-Process -Verb RunAs -FilePath powershell.exe "
            .. "-ArgumentList ('-NoProfile','-Command','%s')"):format(sq(ps_script))
    }

    -- This call will pop the UAC prompt.  If the user accepts, it runs the registry add.
    local out = vim.fn.system(elevate_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("⚠️  Could not add startup entry (administrator privileges required)", vim.log.levels.ERROR)
        return false
    end

    vim.notify("✅  AHK auto-start enabled (HKLM Run key).")
    return true
end

--- Disable AHK auto-start via HKLM Run key (with UAC prompt)
function M.disable()
    -- Build the raw PowerShell snippet we want to run elevated.
    local ps_script = [[
    Remove-ItemProperty `
    -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' `
    -Name 'RemapAHK' `
    -ErrorAction Stop
    ]]

    -- Re-spawn PowerShell *elevated* just for that snippet
    local elevate_cmd = {
        "powershell.exe",
        "-NoProfile",
        "-Command",
        ("Start-Process -Verb RunAs -FilePath powershell.exe "
            .. "-ArgumentList ('-NoProfile','-Command','%s')"):format(sq(ps_script))
    }

    -- This will pop the UAC dialog. If they accept, the key is removed.
    vim.fn.system(elevate_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("⚠️  Could not remove startup entry (administrator privileges required)",
            vim.log.levels.ERROR)
        return false
    end

    vim.notify("❌  AHK auto-start disabled.")
    return true
end

return M
