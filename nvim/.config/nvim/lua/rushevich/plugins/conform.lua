return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                cpp = { "clang_format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
            formatters = {
                clang_format = {
                    prepend_args = { "--style=file:" .. vim.fn.expand("~/project_files/.clang-format") },
                },
            },
        })
    end,
}
