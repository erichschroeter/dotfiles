return {
    {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.9.2",
        event = { "BufReadPost", "BufNewFile" },
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "cpp", "qmldir", "bash", "lua", "vim", "vimdoc", "query" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
                incremental_selection = { enable = true },
                autotag = { enable = true },
                rainbow = { enable = true, disable = { "html" }, extended_mode = false },
            })

            require("ts_context_commentstring").setup({
                enable_autocmd = false,
            })
        end,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-textobjects" },
            { "windwp/nvim-ts-autotag" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
        },
    },
}
