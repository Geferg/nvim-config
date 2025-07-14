local M = {}

local project_root = nil
local host = require("features.host")
local uv = vim.loop

-- Detect project type
local function detect_project_type(root)
    if uv.fs_stat(root .. "/Cargo.toml") then return "rust" end
    if uv.fs_stat(root .. "/Makefile") then return "make" end
    if uv.fs_stat(root .. "/main.py") then return "python" end
    if uv.fs_stat(root .. "/CMakeLists.txt") then return "cmake" end
    return nil
end

local function run_in_term(cmd, cwd)
    -- shell snippet we want to execute *inside* the spawned terminal
    local shell_snippet = string.format(
        "source ~/.profile; cd %q && %s; exec bash",
        cwd,
        cmd
    )

    ---------------------------------------------------------------------------
    -- Build argv for wezterm depending on where Neovim is running
    ---------------------------------------------------------------------------
    local wezterm_cmd

    if host.is_windows() and not host.is_wsl() then
        -------------------------------------------------------------------------
        -- Neovim running on native Windows
        -- We launch a new tab in the user’s default shell (PowerShell here).
        -- (Switch to cmd /C or Git-Bash if that’s your preference.)
        -------------------------------------------------------------------------
        wezterm_cmd = {
            "wezterm.exe", "start", "powershell",
            "-NoLogo", "-NoExit", "-Command", shell_snippet,
        }
    elseif host.is_wsl() then
        -------------------------------------------------------------------------
        -- Neovim running *inside* WSL
        -- We call the Windows copy of wezterm.exe, telling it to
        -- start another WSL instance that runs our shell snippet.
        -------------------------------------------------------------------------
        wezterm_cmd = {
            "wezterm.exe", "start", "wsl",
            "-e", "bash", "-c", shell_snippet,
        }
    elseif host.is_linux() then
        -------------------------------------------------------------------------
        -- Neovim running on “real” Linux (outside WSL)
        -------------------------------------------------------------------------
        wezterm_cmd = {
            "wezterm", "start", "--", "bash", "-c", shell_snippet,
        }
    else
        vim.notify("Unsupported host for run_in_term()", vim.log.levels.ERROR)
        return
    end

    -- Fire and forget
    local ok = vim.fn.jobstart(wezterm_cmd, { detach = true })
    if ok <= 0 then
        vim.notify("Failed to launch external terminal", vim.log.levels.ERROR)
    end
end

function M.neogit_smart_target()
    local root = M.get_project_dir()
    local cmd

    if root and vim.fn.isdirectory(root) == 1 then
        -- Use Neogit with the project directory as the git repo
        cmd = string.format("Neogit cwd=%s", vim.fn.fnameescape(root))
    else
        -- Fallback to Neogit on the current working directory
        cmd = "Neogit"
    end

    vim.cmd(cmd)
end

function M.build_project()
    local root = M.get_project_dir()
    if not root then
        vim.notify("Project directory not set.", vim.log.levels.WARN)
        return
    end

    local project_type = detect_project_type(root)
    local cmd

    if project_type == "rust" then
        cmd = "cargo build"
    elseif project_type == "make" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    elseif project_type == "cmake" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    else
        vim.notify("No known build system in project directory.", vim.log.levels.WARN)
        return
    end

    -- Open terminal in a bottom split and run build command
    vim.cmd("botright split | resize 15")
    local term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, term_buf)
    vim.fn.termopen(cmd, { cwd = root })
    vim.cmd("startinsert") -- optional: jump into terminal mode immediately
end

function M.run_project()
    local root = M.get_project_dir()
    if not root then
        vim.notify("Project directory not set.", vim.log.levels.WARN)
        return
    end

    local project_type = detect_project_type(root)
    local cmd

    if project_type == "rust" then
        local binary = vim.fn.fnamemodify(root, ":t") -- use actual folder name
        cmd = string.format("cargo build --quiet && ./target/debug/%s", binary)
    elseif project_type == "make" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    elseif project_type == "python" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    elseif project_type == "cmake" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    else
        vim.notify("No known run command for project type.", vim.log.levels.WARN)
        return
    end

    run_in_term(cmd, root)
end

function M.clean_project()
    local root = M.get_project_dir()
    if not root then
        vim.notify("Project directory not set.", vim.log.levels.WARN)
        return
    end

    local project_type = detect_project_type(root)
    local cmd

    if project_type == "rust" then
        cmd = "cargo clean"
    elseif project_type == "make" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    elseif project_type == "python" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    elseif project_type == "cmake" then
        vim.notify("Functionality not implemented for this project type.", vim.log.levels.WARN)
    else
        vim.notify("No known run command for project type.", vim.log.levels.WARN)
        return
    end

    run_in_term(cmd, root)
end

local project_generators = {}

project_generators.rust = function(name)
    local cwd = vim.fn.getcwd()
    local path = cwd .. "/" .. name
    local result = vim.fn.system({ "cargo", "new", path })

    if vim.v.shell_error ~= 0 then
        vim.notify("Failed to generate Rust project:\n" .. result, vim.log.levels.ERROR)
        return
    end

    require("features.project").set_project_dir_explicit(path)
    vim.cmd("e " .. path .. "/src/main.rs")
    vim.notify("Rust project '" .. name .. "' created!", vim.log.levels.INFO)
end

project_generators.ratatui = function(name)
    local cwd = vim.fn.getcwd()
    local path = cwd .. "/" .. name

    local result = vim.fn.system({
        "cargo", "generate",
        "--define", "description=",
        "ratatui/templates", "simple",
        "--name", name,
        "--silent",
        "--force"
    })

    if vim.v.shell_error ~= 0 then
        vim.notify("Failed to generate Ratatui project:\n" .. result, vim.log.levels.ERROR)
        return
    end

    require("features.project").set_project_dir_explicit(path)
    vim.cmd("e " .. path .. "/src/main.rs")
    vim.notify("Ratatui project '" .. name .. "' created!", vim.log.levels.INFO)
end

function M.generate_project(kind)
    local generator = project_generators[kind]
    if not generator then
        vim.notify("Unsupported project type: " .. kind, vim.log.levels.WARN)
        return
    end

    vim.ui.input({ prompt = "Project name (" .. kind .. "): " }, function(name)
        if not name or name == "" then
            vim.notify("No project name provided.", vim.log.levels.WARN)
            return
        end
        generator(name)
    end)
end

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

function M.set_project_dir_explicit(path)
    project_root = path
    vim.notify("Project root set to:\n" .. path, vim.log.levels.INFO)
end

return M
