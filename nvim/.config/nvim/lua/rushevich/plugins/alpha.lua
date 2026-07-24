-- alpha.lua
return {
    "goolord/alpha-nvim",
    -- dependencies = { 'nvim-mini/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons',
        'MaximilianLloyd/ascii.nvim'
    },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        dashboard.config.layout = {
            { type = "padding", val = 8 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer
        }
        -- local ascii = require("ascii")
        -- dashboard.section.header.val = ascii.art.computers.apple.logo
        -- dashboard.section.header.val = ascii.text.neovim.colossal
        dashboard.section.header.val = {
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
        }
        dashboard.section.buttons.val = {
            dashboard.button("b", "  ->  Browse files", ":Oil<cr>"),
            dashboard.button("z", "  ->  Browse zoxide",
                "<cmd>lua require('telescope').extensions.zoxide.list()<cr>"),
            dashboard.button("f", "󰍉  ->  Find file", "<cmd>Telescope find_files<cr>"),
            dashboard.button("r", "  ->  Recent files", "<cmd>Telescope oldfiles<cr>"),
        }

        local stats = require("lazy").stats()
        dashboard.section.footer.val = stats.count .. " plugins loaded"
        alpha.setup(dashboard.config)
    end,
}
