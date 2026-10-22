return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.setup({})

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup(
                    "TreesitterHighlight",
                    { clear = true }
                ),
                callback = function(event)
                    local filetype = vim.bo[event.buf].filetype
                    local language = vim.treesitter.language.get_lang(filetype)

                    if language
                        and vim.tbl_contains(ts.get_installed(), language)
                    then
                        vim.treesitter.start(event.buf, language)
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
    },
    {
        "windwp/nvim-ts-autotag",
        opts = {},
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        },
    },
}
