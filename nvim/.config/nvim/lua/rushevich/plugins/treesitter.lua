-- lua/rushevich/plugins/treesitter.lua
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local ts = require("nvim-treesitter")

        local parsers = {
            "c", "cpp", "lua", "vim", "vimdoc", "query",
            "rust", "python", "bash",
            "json", "yaml", "toml",
            "markdown", "markdown_inline",
            "html", "css", "javascript", "typescript", "tsx",
            "gitignore", "diff", "dockerfile",
        }

        ts.install(parsers)

        -- enable native highlighting per buffer
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local buf = args.buf
                if vim.bo[buf].filetype ~= "" then
                    return
                end
                local ft = vim.bo[buf].filetype
                local lang = vim.treesitter.language.get_lang(ft)
                if not lang then
                    return
                end
                if not vim.treesitter.language.add(lang) then
                    return
                end
                -- only start if a parser is actually available for this lang
                if pcall(vim.treesitter.language.add, lang) then
                    vim.treesitter.start(buf, lang)
                end
            end,
        })
    end,
}
