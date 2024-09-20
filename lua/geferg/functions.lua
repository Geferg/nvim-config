-- Set Debug as default mode
BuildMode = "Debug"

function SetBuildMode(mode)
    if mode == "Debug" or mode == "Release" then
        BuildMode = mode
        print("Build mode set to: " .. BuildMode)
    else
        print("Invalid build mode.")
    end
end

function RunProgram()
    local function start_exe()
        local cwd = vim.fn.getcwd()
        local project_name = cwd:match("([^\\]+)$")
        local exe_path = cwd .. "\\" .. BuildMode .. "\\" .. project_name .. ".exe"

        local run_command = 'start cmd /c "' .. exe_path .. '"'
        vim.cmd("silent !" .. run_command)
    end

    vim.defer_fn(start_exe, 100)
end

function RunTests()
    local cwd = vim.fn.getcwd()
    local project_name = cwd:match("([^\\]+)$")
    local test_exe = cwd .. '/Debug/bin/' .. project_name .. '-tests'

    -- Check if the executable exists and is executable
    if not vim.fn.executable(test_exe) then
        print("Executable does not exist or is not runnable: " .. test_exe)
        return
    end

    -- Find or create a buffer for the output
    local buf = nil
    local buf_tag = "unit_test_output_buffer"
    local existing_buffers = vim.api.nvim_list_bufs()
    for _, b in ipairs(existing_buffers) do
        -- Safely check for the buffer tag
        local success, result = pcall(vim.api.nvim_buf_get_var, b, buf_tag)
        if success and result then
            buf = b
            break
        end
    end

    if not buf then
        buf = vim.api.nvim_create_buf(false, true)
        -- Set a buffer variable to tag this buffer
        vim.api.nvim_buf_set_var(buf, buf_tag, true)
    else
        -- Clear the existing buffer's lines to reuse it
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    end

    -- Ensure the buffer is displayed in a window, create a split if not displayed
    local win_id = vim.fn.bufwinid(buf)
    if win_id == -1 then
        vim.api.nvim_command('belowright split')
        vim.api.nvim_win_set_buf(vim.fn.win_getid(), buf)
    end

    -- Execute the test executable
    local command = test_exe
    local on_stdout = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    local clean_line = line:gsub("\r$", "")
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {clean_line})
                end
            end
        end
    end

    local opts = {
        on_stdout = on_stdout,
        on_stderr = on_stdout,  -- Using same handler for simplicity
        stdout_buffered = false,
        stderr_buffered = false
    }

    vim.fn.jobstart(command, opts)
end

function RunTests2()
    local cwd = vim.fn.getcwd()
    local project_name = cwd:match("([^\\]+)$")
    local test_exe = cwd .. '/Debug/bin/' .. project_name .. '-tests'

    -- Check if the executable exists and is executable
    if not vim.fn.executable(test_exe) then
        print("Executable does not exist or is not runnable: " .. test_exe)
        return
    end

    -- Find or create a buffer for the output
    local buf = nil
    local buf_tag = "unit_test_output_buffer"
    local existing_buffers = vim.api.nvim_list_bufs()
    for _, b in ipairs(existing_buffers) do
        if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_var(b, buf_tag) ~= nil then
            buf = b
            break
        end
    end

    if not buf then
        buf = vim.api.nvim_create_buf(false, true)
        -- Instead of setting a global name, use a buffer variable
        vim.api.nvim_buf_set_var(buf, buf_tag, true)
    else
        -- Clear the existing buffer's lines to reuse it
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    end

    -- Ensure the buffer is displayed in a window, create a split if not displayed
    local win_id = vim.fn.bufwinid(buf)
    if win_id == -1 then
        vim.api.nvim_command('belowright split')
        vim.api.nvim_win_set_buf(vim.fn.win_getid(), buf)
    end

    -- Execute the test executable
    local command = test_exe
    local on_stdout = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    local clean_line = line:gsub("\r$", "")
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {clean_line})
                end
            end
        end
    end

    local opts = {
        on_stdout = on_stdout,
        on_stderr = on_stdout,  -- Using same handler for simplicity
        stdout_buffered = false,
        stderr_buffered = false
    }

    vim.fn.jobstart(command, opts)
end

-- Function to clean CMake build files
function CleanCMakeBuild()
    local build_dir = vim.fn.getcwd() .. '\\' .. BuildMode

    if vim.fn.isdirectory(build_dir) == 1 then
        vim.fn.delete(build_dir, 'rf')
        print("Removed build directory: " .. build_dir)
    else
        print("Build directory does not exist: " .. build_dir)
    end
end

function CMakeBuildAndRun()
    BuildCMakeProject(function(success)
        if success then
            RunProgram()
        else
            print("Build failed.")
        end
    end)
end

function GenerateBuildFilesTraced()
    if BuildMode == "" then
        print("Build mode not set! Use :SetBuildMode first.")
        return
    end

    local build_dir = vim.fn.getcwd() .. '/' .. BuildMode
    local cmake_cmd = 'cmake -G "Ninja" --trace-source="CMakeLists.txt" -DCMAKE_BUILD_TYPE=' .. BuildMode .. ' -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -B ' .. build_dir

    -- Create a buffer and a window for the output
    local buf = vim.api.nvim_create_buf(false, true)  -- create a new empty buffer
    vim.api.nvim_command('belowright split')                        -- open a new vertical split
    vim.api.nvim_win_set_buf(0, buf)                  -- set current window to the new buffer

    -- Define handler functions
    local on_stdout = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local on_stderr = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local opts = {
        on_stdout = on_stdout,
        on_stderr = on_stderr,
        stdout_buffered = false,
        stderr_buffered = false
    }

    vim.fn.jobstart(cmake_cmd, opts)
end

-- Function to generate build files based on the current build mode and output to a new split
function GenerateBuildFiles()
    if BuildMode == "" then
        print("Build mode not set! Use :SetBuildMode first.")
        return
    end

    local build_dir = vim.fn.getcwd() .. '/' .. BuildMode
    local cmake_cmd = 'cmake -G "Ninja" -DCMAKE_BUILD_TYPE=' .. BuildMode ..
                      ' -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -B ' .. build_dir

    -- Additional command to copy compile_commands.json
    local copy_cmd = 'copy /Y ' .. string.gsub(build_dir, '/', '\\') .. '\\compile_commands.json ' .. string.gsub(vim.fn.getcwd(), '/', '\\')

    -- Create a buffer and a window for the output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_command('belowright split')
    vim.api.nvim_win_set_buf(0, buf)

    local function handle_job_completion(job_id, data, event_type)
        if event_type == "exit" and data == 0 then  -- Check if job completed successfully
            vim.fn.jobstart(copy_cmd, {detach = true})  -- Detach means no need to handle output
        end
    end

    local opts = {
        on_stdout = function(job_id, data, event_type)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                    end
                end
            end
        end,
        on_stderr = function(job_id, data, event_type)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                    end
                end
            end
        end,
        on_exit = handle_job_completion
    }

    vim.fn.jobstart(cmake_cmd, opts)
end

function GenerateBuildFiles2()
    if BuildMode == "" then
        print("Build mode not set! Use :SetBuildMode first.")
        return
    end

    local build_dir = vim.fn.getcwd() .. '/' .. BuildMode
    local cmake_cmd = 'cmake -G "Ninja" -DCMAKE_BUILD_TYPE=' .. BuildMode .. ' -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -B ' .. build_dir

    -- Create a buffer and a window for the output
    local buf = vim.api.nvim_create_buf(false, true)  -- create a new empty buffer
    vim.api.nvim_command('belowright split')                        -- open a new vertical split
    vim.api.nvim_win_set_buf(0, buf)                  -- set current window to the new buffer

    -- Define handler functions
    local on_stdout = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local on_stderr = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local opts = {
        on_stdout = on_stdout,
        on_stderr = on_stderr,
        stdout_buffered = false,
        stderr_buffered = false
    }

    vim.fn.jobstart(cmake_cmd, opts)
end

-- Function to build the CMake project
function BuildCMakeProject(callback)
    if BuildMode == "" then
        print("Build mode not set! Use :SetBuildMode first.")
        return
    end

    local build_dir = vim.fn.getcwd() .. '/' .. BuildMode
    local build_cmd = 'ninja -C ' .. build_dir

    -- Open a new horizontal split for output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_command('belowright split')
    vim.api.nvim_win_set_buf(0, buf)

    local on_stdout = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local on_stderr = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local on_exit = function(job_id, exit_code, event_type)
        if exit_code == 0 then
            if callback then
                callback(true)
            end
        else
            print("Build failed with exit code: " .. exit_code)
            if callback then
                callback(false)
            end
        end
    end

    local opts = {
        on_stdout = on_stdout,
        on_stderr = on_stderr,
        on_exit = on_exit,
        stdout_buffered = false,
        stderr_buffered = false
    }

    vim.fn.jobstart(build_cmd, opts)
    print("Building in: " .. build_dir)
end

-- Function to install the CMake project
function CMakeInstallProject()
    if BuildMode == "" then
        print("Build mode not set! Use :SetBuildMode first.")
        return
    end

    local build_dir = vim.fn.getcwd() .. '/' .. BuildMode
    local install_cmd = 'ninja -C ' .. build_dir .. ' install'

    -- Open a new horizontal split for output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_command('belowright split')
    vim.api.nvim_win_set_buf(0, buf)

    local on_stdout = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local on_stderr = function(job_id, data, event_type)
        if data then
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
                end
            end
        end
    end

    local opts = {
        on_stdout = on_stdout,
        on_stderr = on_stderr,
        stdout_buffered = false,
        stderr_buffered = false
    }

    vim.fn.jobstart(install_cmd, opts)
    print("Installing from: " .. build_dir)
end

function SetWorkingDir()
    local netrw_dir = vim.fn.expand('%:p:h')
    vim.cmd('lcd ' .. netrw_dir)
    print("new wd: " .. netrw_dir)
end

