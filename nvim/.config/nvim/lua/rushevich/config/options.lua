local opt = vim.opt
-- opt
opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus" -- can interop nvim and system cb
opt.expandtab = true          -- use spaces for tab
-- vim.opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- case sensitive if searching with cap
opt.mousehide = true  -- hide mouse while typing
opt.scrolloff = 6     -- min 6 lines around cursor
-- check out vim.opt.shortmess
opt.showtabline = 2

-- whats the sign column?
opt.signcolumn = "yes"

-- vim thesaurus? what ??

opt.wrap = false
opt.undofile = true
opt.showmode = false
