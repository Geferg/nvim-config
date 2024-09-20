vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "View project" })

-- Windows splits
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close current splits"})

-- CMake
vim.api.nvim_set_keymap('n', '<leader>cg',  '<cmd>CMakeGenerate<CR>',   { noremap = true, silent = true, desc = "Generate CMake"})
vim.api.nvim_set_keymap('n', '<leader>cd',  '<cmd>CMakeDir<CR>',        { noremap = true, silent = true, desc = "Set CMake directory" })
vim.api.nvim_set_keymap('n', '<leader>cc',  '<cmd>CMakeClean<CR>',      { noremap = true, silent = true, desc = "Clean CMake" })
vim.api.nvim_set_keymap('n', '<leader>csd', '<cmd>CMakeSetDebug<CR>',   { noremap = true, silent = true, desc = "Set CMake to debug build" })
vim.api.nvim_set_keymap('n', '<leader>csr', '<cmd>CMakeSetRelease<CR>', { noremap = true, silent = true, desc = "Set CMake to release build" })
vim.api.nvim_set_keymap('n', '<leader>cb',  '<cmd>CMakeBuild<CR>',      { noremap = true, silent = true, desc = "Build CMake from generated files" })
vim.api.nvim_set_keymap('n', '<leader>ci',  '<cmd>CMakeInstall<CR>',    { noremap = true, silent = true, desc = "Install CMake using build" })
vim.api.nvim_set_keymap('n', '<leader>ct',  '<cmd>CMakeTrace<CR>',      { noremap = true, silent = true, desc = "Generate CMake with trace" })
vim.api.nvim_set_keymap('n', '<leader>cr',  '<cmd>CMakeRun<CR>',        { noremap = true, silent = true, desc = "Run the current build" })
vim.api.nvim_set_keymap('n', '<leader>cj',  '<cmd>CMakeJob<CR>',        { noremap = true, silent = true, desc = "Build and run the current build" })
vim.api.nvim_set_keymap('n', '<leader>ct',  '<cmd>RunUnitTests<CR>',    { noremap = true, silent = true, desc = "Run unit tests in debug build" })

-- LSP
vim.api.nvim_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true, desc = "Show LSP actions" })


--vim.keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<CR>", { desc = "Generate CMake" })
--vim.keymap.set("n", "<leader>cd", function()
--    vim.cmd("CMakeBuild")
--    vim.cmd([[
--    augroup cmake_group
--        autocmd!
--        autocmd User CMakeBuildSucceeded ++once lua run_program()
--    augroup END
--    ]])
--end,
--{ desc = "Build CMake and run" }
--)


vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = "Find word" })

vim.api.nvim_create_user_command(
    'Snd',
    function()
        local netrw_dir = vim.fn.expand('%:p:h')    -- Get the directory of the current file
        vim.cmd('lcd ' .. netrw_dir)                -- Change the local directory to netrw_dir
        print("new wd: " .. netrw_dir)              -- Echo new dir
    end,
    {}
)

function resize_window_to_content()
    local max_width = 0
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for _, line in pairs(lines) do
        local line_width = vim.fn.strwidth(line)
        if line_width > max_width then
            max_width = line_width
        end
    end

    local final_width = max_width + 10
    vim.cmd('vertical resize ' .. final_width)
end

vim.api.nvim_set_keymap('n', '<leader>rw', '<cmd>lua resize_window_to_content()<CR>', { noremap = true, silent = true })
