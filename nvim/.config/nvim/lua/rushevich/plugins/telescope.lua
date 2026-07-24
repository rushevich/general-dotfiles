-- telescope.lua
return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        'jvgrootveld/telescope-zoxide',
        'MaximilianLloyd/ascii.nvim'
    },
    config = function()
        require("telescope").setup({
            defaults = {
                prompt_prefix = "❯ ",
                selection_caret = "❯ ",
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                zoxide = {
                    prompt_title = "[ Walking on the shoulders of giants ]",
                    mappings = {
                        default = {
                            action = function(selection)
                                vim.cmd.cd(selection.path)
                            end,
                            after_action = function(selection)
                                vim.notify("cwd → " .. selection.path)
                            end,
                        },
                        ["<C-s>"] = {
                            action = function(selection)
                                vim.cmd.edit(selection.path)
                            end,
                        },
                        ["<C-t>"] = {
                            action = function(selection)
                                vim.cmd.tcd(selection.path) -- tab-local cwd change
                            end,
                        },
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                },
            }
        })
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('ascii')
        require('telescope').load_extension('zoxide')
        local builtin = require('telescope.builtin')
        local km = vim.keymap.set
        km("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
        km("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
        km("n", "<leader>fd",
            function()
                require("telescope").extensions.zoxide.list()
            end, { desc = "Zoxide directory jump" })
        km("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "Search document symbols" })
        km("n", "<leader>fc", builtin.colorscheme, { desc = "Pick colorscheme" })
        -- km("n", "<leader>fa", ":Telescope ascii<CR>", "Search ascii")
        km("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Telescope recent files" })
    end,
}
