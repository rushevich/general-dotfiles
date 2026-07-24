-- basic keymaps
local km = vim.keymap.set

vim.g.mapleader = " "

km("n", "<leader>w", ":w<CR>", { desc = "Write file" })
km("n", "<leader>q", ":q<CR>", { desc = "Quit buffer" })
km("n", "<Esc>", ":nohlsearch<CR>")
km("n", "<C-d>", "<C-d>zz")
km("n", "<C-u>", "<C-u>zz")
km("n", "<C-j>", "<C-w>j")
km("n", "<C-k>", "<C-w>k")

-- navigation
-- km("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
-- km("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
-- km("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
-- km("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- info
-- km("n", "K", vim.lsp.buf.hover)

-- actions
-- km("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
-- km("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
-- km("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format code" })

-- diagnostics
-- km("n", "<leader>de", vim.diagnostic.open_float, { desc = "Diagnostic float" })
-- km("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- tabs
local u = require("rushevich.util.keymap")
u.map("vn", "tabnew", "New tab", { cmd = true })
u.map("vp", "tabprevious", "Previous tab", { cmd = true })
u.map("vc", "tabclose", "Close tab", { cmd = true })
u.map("<cr>", "i<cr><esc>", "New line", { mode = "n" })
