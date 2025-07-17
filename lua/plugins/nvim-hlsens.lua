return {
    {
        "kevinhwang91/nvim-hlslens",
        event = "VeryLazy",
        -- WARNING: Uses bad lazy spec
        config = function()
            require("hlslens").setup({
                calm_down = true,
                nearest_only = false,
            })

            local lens = require("hlslens")

            local function nmap(key)
                vim.keymap.set("n", key, function()
                    vim.cmd("normal! " .. key)
                    lens.start()
                end, { noremap = true, silent = true })
            end

            for _, k in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
                nmap(k)
            end
        end
    }
}
