return {
    {
        "rcarriga/nvim-notify",
        lazy = false,
        -- WARNING: Uses bad lazy spec
        config = function()
            vim.notify = require("notify")
        end,
    },
}
