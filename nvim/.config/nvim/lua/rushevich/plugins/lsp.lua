-- lsp.lua
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- dependencies = {
    --     { "antosha417/nvim-lsp-file-operations", config = true },
    -- },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- diagnostics symbols
        vim.diagnostic.config({
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.HINT] = "",
                    [vim.diagnostic.severity.INFO] = "",
                }
            }
        })

        vim.diagnostic.config({
            virtual_text = { prefix = "●", spacing = 2 },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = { border = "rounded", source = true },
        })

        -- keymaps, inlay hints, semantic-token opt-out
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                if client and client.server_capabilities.semanticTokensProvider then
                    client.server_capabilities.semanticTokensProvider = nil
                end

                local u = require("rushevich.util.keymap")
                local base = { buffer = ev.buf, silent = true }

                local function with(extra)
                    return vim.tbl_extend("force", base, extra or {})
                end

                u.map("gR", "Telescope lsp_references", "Show LSP references", with({ cmd = true }))
                u.map("gD", vim.lsp.buf.declaration, "Go to declaration", with())
                u.map("gd", vim.lsp.buf.definition, "Go to definition", with())
                u.map("gi", "Telescope lsp_implementations", "Show LSP implementations", with({ cmd = true }))
                u.map("gt", "Telescope lsp_type_definitions", "Show LSP type definitions", with({ cmd = true }))
                u.map("ca", vim.lsp.buf.code_action, "See available code actions",
                    with({ leader = true, mode = { "n", "v" } }))
                u.map("rn", vim.lsp.buf.rename, "Smart rename", with({ leader = true }))
                u.map("D", "Telescope diagnostics bufnr=0", "Show buffer diagnostics",
                    with({ leader = true, cmd = true }))
                u.map("de", vim.diagnostic.open_float, "Show line diagnostics", with({ leader = true }))
                u.map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Go to previous diagnostic", with())
                u.map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Go to next diagnostic", with())
                -- u.map("K", vim.lsp.buf.hover, "Show documentation under cursor", with())
                u.map("K", function()
                    vim.lsp.buf.hover { border = "rounded", max_height = 25, max_width = 120 }
                end, "Show documentation under cursor", with())
                u.map("ih", function()
                    local b = vim.api.nvim_get_current_buf()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = b }), { bufnr = b })
                end, "Toggle inlay hints", with({ leader = true }))
                u.map("rs", "lsp restart", "Restart LSP", with({ leader = true, cmd = true }))


                -- on by default except C/C++ and header files
                local ft = vim.bo[ev.buf].filetype
                local path = vim.api.nvim_buf_get_name(ev.buf)
                local skip = vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft)
                    or path:match("%.h$") or path:match("%.hh$")
                    or path:match("%.hpp$") or path:match("%.hxx$")
                    or path:match("%.inl$")
                if client and client:supports_method("textDocument/inlayHint") and not skip then
                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                end
            end,
        })

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("UserLspFormat", {}),
            callback = function(ev)
                local ft = vim.bo[ev.buf].filetype
                if ft == "typst" then
                    require("conform").format({ bufnr = ev.buf })
                    return
                end
                if vim.tbl_contains({ "c", "cpp", "objc", "objcpp" }, ft) then
                    vim.lsp.buf.format({
                        bufnr = ev.buf,
                        async = false,
                        filter = function(c) return c.name == "clangd" end,
                    })
                end
            end,
        })

        -- server configurations
        vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--query-driver=/usr/bin/clang++",
            },
            init_options = {
                fallbackFlags = { "-std=c++23" },
            },
        })
        vim.lsp.enable("clangd")

        vim.lsp.config("ts_ls", {
            capabilities = capabilities,
            filetypes = {
                "typescript", "typescriptreact",
                "javascript", "javascriptreact",
            },
        })

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                    hint = { enable = true }, -- lua_ls inlay hints
                },
            },
        })

        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    inlayHints = {
                        typeHints = { enable = true },
                        parameterHints = { enable = true },
                        chainingHints = { enable = true },
                        bindingModeHints = { enable = false },
                        closureReturnTypeHints = { enable = "never" },
                        lifetimeElisionHints = { enable = "never" },
                        reborrowHints = { enable = false },
                        closingBraceHints = { enable = false },
                    },
                },
            },
        })

        vim.lsp.config("pyright", {
            capabilities = capabilities,
        })

        vim.lsp.config("tinymist", {
            capabilities = capabilities,
            cmd = { "tinymist" },
            filetypes = { "typst" },
            root_markers = { ".git" },
        })

        vim.lsp.config("gdscript", {
            capabilities = capabilities,
        })

        -- enable servers
        local servers = {
            "clangd", "ts_ls", "lua_ls", "rust_analyzer",
            "pyright", "tinymist", "gdscript",
        }
        for _, s in ipairs(servers) do
            vim.lsp.enable(s)
        end

        if vim.fn.executable("haskell-language-server-wrapper") == 1 then
            vim.lsp.config("hls", {
                capabilities = capabilities,
                cmd = { "haskell-language-server-wrapper", "--lsp" },
                filetypes = { "haskell", "lhaskell", "cabal" },
                root_markers = {
                    "hie.yaml", "stack.yaml", "cabal.project",
                    "package.yaml", "*.cabal", ".git",
                },
            })
            vim.lsp.enable("hls")
        end

        if vim.fn.executable("gdshader-lsp") == 1 then
            vim.lsp.config("gdshader_lsp", { capabilities = capabilities })
            vim.lsp.enable("gdshader_lsp")
        end
    end,
}
