-- return {
--     "epwalsh/obsidian.nvim",
--     version = "*", -- recommended, use latest release instead of latest commit
--     lazy = true,
--     ft = "markdown",
--     -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
--     event = {
--         --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
--         --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
--         --   -- refer to `:h file-pattern` for more examples
--         "BufReadPre " .. vim.fn.expand "~" .. "/Documents/rushevich_vault/*.md",
--         "BufNewFile " .. vim.fn.expand "~" .. "/Documents/rushevich_vault/*.md",
--     },
--     dependencies = {
--         -- Required.
--         "nvim-lua/plenary.nvim",
--     },
--     opts = {
--
--         templates = {
--             folder = "Templates",
--         },
--
--         picker = {
--             name = "telescope.nvim",
--             --note_mappings = {},
--             --tag_mappings = {},
--         },
--
--         open_notes_in = "current",
--
--         attachments = {
--             img_folder = "Database/Media",
--             ---@return string
--             img_name_func = function()
--                 return string.format("%s-", os.time())
--             end,
--
--             ---@param client obsidian.Client
--             ---@param path obsidian.Path the absolute path to the image file
--             ---@return string
--             img_text_func = function(client, path)
--                 path = client:vault_relative_path(path) or path
--                 return string.format("![%s](%s)", path.name, path)
--             end,
--         }
--     },
-- }
-- ***************************** --
--     OLD CONFIG ON UNMAINTAINED VERS ABOVE
-- ***************************** --
return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release, remove to use latest commit
    ---@module 'obsidian'
    ---@type obsidian.config
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        legacy_commands = false, -- this will be removed in 4.0.0
        workspaces = {
            {
                name = "main_vault",
                path = "~/Documents/rushevich_vault/",
            },
        },
        picker = {
            name = "telescope.nvim",
        },
        attachments = {
            folder = "Database/Media",
        },
        new_notes_location = "current_dir",
        sync = {
            enabled = false,
        },
        templates = {
            folder = "Templates",
        },
        daily_notes = {
            folder = "Personal/Daily",
        }
    },
    config = function(_, opts)
        require("obsidian").setup(opts)

        local function o_km(suffix, cmd, desc)
            vim.keymap.set("n", "<leader>" .. suffix, ":Obsidian " .. cmd .. "<CR>", { desc = desc })
        end
        -- km("n", "<leader>on", ":Obsidian new<CR>")
        -- km("n", "<leader>os", ":Obsidian search<CR>")
        o_km("on", "new", "New note")
        o_km("os", "search", "Search vault")
        o_km("oq", "quick_switch", "Quick switch")
        o_km("ot", "today", "Today's daily note")
        o_km("ob", "backlinks", "Backlinks")
    end,
}
