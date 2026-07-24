return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local bufferline = require("bufferline")

        local function hl(name)
            return vim.api.nvim_get_hl(0, { name = name, link = false })
        end

        local function sync_bufferline()
            local normal = hl("Normal")
            local tabline = hl("TabLine")
            local sel = hl("TabLineSel")
            local fill = hl("TabLineFill")

            local fill_bg = (fill and fill.bg) or (tabline and tabline.bg) or (normal and normal.bg)
            if fill_bg then
                vim.api.nvim_set_hl(0, "BufferLineFill", { bg = fill_bg })
            end
            if not normal then
                return
            end

            local function fg_or_nil(name)
                local fg = hl(name)
                return fg and fg.fg or nil
            end
        end


        local options = {
            options = {
                mode = "buffers",
                indicator = {
                    style = 'underline',
                },
                show_buffer_icons = true,
                show_buffer_close_icons = false,
                show_close_icons = false,
                separator_style = 'thin',
                tab_size = 20,
                diagnostics = "nvim_lsp",
                always_show_bufferline = true,
            }
        }

        bufferline.setup(options)
        sync_bufferline()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("ThemeBufferLineSync", { clear = true }),
            callback = function()
                sync_bufferline()
            end
        })

        local u = require("rushevich.util.keymap")
        u.map("bc", "BufferLinePickClose", "Pick buffer to close", { leader = true, cmd = true })
        u.map("bp", "BufferLinePick", "Pick buffer", { leader = true, cmd = true })
    end,
}
