-- registry.lua
local M = {}

local function expand(__repo, ...) -- = schemes variadic
    return {
        repo = __repo,
        schemes = { ... },
    }
end

M.items = {
    expand('AlexvZyl/nordic.nvim', "nordic"),
    expand('nyoom-engineering/oxocarbon.nvim', 'oxocarbon'),
    expand('kepano/flexoki-neovim', 'flexoki'),
    expand('oskarnurm/koda.nvim', 'koda-dark', 'koda-light', 'koda-moss', 'koda-glade'),
    expand('morhetz/gruvbox', 'gruvbox'),
    expand('slugbyte/lackluster.nvim', 'lackluster-hack', 'lackluster-mint', 'lackluster'),
    expand('vague-theme/vague.nvim', 'vague'),
    expand('cocopon/iceberg.vim', 'iceberg'),
    expand('bettervim/yugen.nvim', 'yugen'),
    expand('everviolet/nvim', 'winter', 'fall', 'spring', 'summer'),
    expand('uhs-robert/oasis.nvim', 'oasis', 'oasis-moonlight', 'oasis-starlight', 'oasis-night'),
    expand('datsfilipe/vesper.nvim', 'vesper'),
    expand('folke/tokyonight.nvim', 'tokyonight', 'tokyonight-night', 'tokyonight-storm', 'tokyonight-moon'),
    expand('ThorstenRhau/token', 'token'),
}

function M.names()
    local names = {}
    for _, val in ipairs(M.items) do
        vim.list_extend(names, val.schemes)
    end

    return names
end

return M
