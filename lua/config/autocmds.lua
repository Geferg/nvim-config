-- Prevent comment continuation
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Trim trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Auto reload file when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "checktime",
})

-- Auto create nested directories
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        local dir = vim.fn.expand("<afile>:p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Propper filetypes for uncommon extensions
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.cconf",
    command = "set filetype=conf",
})


-- Restore last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.fn.line([['"]])
        if mark > 1 and mark <= vim.fn.line("$") then
            vim.cmd('normal! g`"')
        end
    end,
})

-- Track last non-Neo-tree file vuffer for toggle navigation
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local ft = vim.bo.filetype
        if ft ~= "neo-tree" and ft ~= "" then
            vim.g.last_file_bufnr = vim.api.nvim_get_current_buf()
        end
    end,
})

-- Autoformat on save if LSP supports formatting, otherwise fallback to gg=G
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {
        "*.c", "*.cpp", "*.h", "*.hpp",       -- C/C++
        "*.rs",                               -- Rust
        "*.py",                               -- Python
        "*.lua",                              -- Lua
        "*.js", "*.jsx", "*.ts", "*.tsx",     -- JavaScript / TypeScript
        "*.json", "*.jsonc",                  -- JSON
        "*.yml", "*.yaml",                    -- YAML
        "*.toml", "*.ini", "*.conf",          -- Config files
        "*.sh", "*.bash", "*.zsh",            -- Shell scripts
        "*.go",                               -- Go
        "*.java", "*.kt",                     -- Java / Kotlin
        "*.php",                              -- PHP
        "*.rb",                               -- Ruby
        "*.html", "*.htm", "*.css", "*.scss", -- Web
        "*.tex",                              -- LaTeX
        "*.sql",                              -- SQL
        "*.vim",                              -- Vimscript
    },
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local can_format = false

        for _, client in ipairs(clients) do
            if client:supports_method("textDocument/formatting") then
                can_format = true
                break
            end
        end

        if can_format then
            vim.lsp.buf.format({ async = false })
        else
            vim.cmd("normal! gg=G")
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        --print("LspAttach triggered for client " .. vim.lsp.get_client_by_id(args.data.client_id).name)
    end,
})

-- Focus ignores
local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

local ignore_buftypes = { 'nofile', 'prompt', 'popup' }
vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        then
            vim.w.focus_disable = true
        else
            vim.w.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

local ignore_filetypes = { 'neo-tree' }
vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        else
            vim.b.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})
