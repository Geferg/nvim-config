return {
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            local files = require("features.files")
            local themes_dir = files.this_dir(1) .. "themes/"
            local file_type = "lua"
            local include_extension = false
            local themes = files.list_files(themes_dir, file_type, include_extension)

            require("themery").setup({
                themes = themes,
            })
        end
    }
}
