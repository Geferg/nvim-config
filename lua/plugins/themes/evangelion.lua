return {
    {
        "xero/evangelion.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("evangelion").setup()
        end
    },
}
