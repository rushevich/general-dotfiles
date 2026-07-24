vim.api.nvim_create_autocmd("FileType", {
    pattern = "alpha",
    callback = function()
        vim.opt_local.fillchars = { eob = " " }
    end,
})

-- autocommand to set conceal level to 2 while in markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.wrap = true
    end,
})

local function override_yugen()
    local visual = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { fg = visual.fg, bg = visual.bg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("YugenOverrides", { clear = true }),
    callback = function(args)
        if args.match == 'yugen' then
            override_yugen()
        end
    end,
})

if vim.g.colors_name == 'yugen' then
    override_yugen()
end
