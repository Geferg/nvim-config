return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- WARNING: Uses bad lazy spec
        config = function()
            require("harpoon"):setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                    key = function()
                        return "global"
                    end,
                }
            })
        end,
    }
}
