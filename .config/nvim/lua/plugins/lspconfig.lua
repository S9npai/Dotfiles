-- lua/plugins/lspconfig.lua

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "folke/neodev.nvim",
        "petertriho/nvim-scrollbar",
        "ray-x/lsp_signature.nvim",
        "mason-org/mason-lspconfig.nvim"
    },

    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        -- CRITICAL: Get capabilities from nvim-cmp
        local capabilities = cmp_nvim_lsp.default_capabilities()

        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- Go to definition
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            -- Go to declaration
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            -- Go to implementation
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            -- View documentation/type info on hover
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            -- Show diagnostic (error/warning) under cursor
            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
            -- Go to previous diagnostic
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            -- Go to next diagnostic
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

            -- Code Actions Menu (Image 1 functionality)
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
                { buffer = bufnr, desc = "LSP Code Action" })

            -- Rename a symbol globally
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP Rename" })
            -- Show references to the symbol under the cursor
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            -- Format the buffer
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, { buffer = bufnr, desc = "LSP Format File" })

            -- Highlight symbol under cursor
            if client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
                vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    group = "lsp_document_highlight",
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    group = "lsp_document_highlight",
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end

        -- Setup neodev BEFORE lspconfig
        require("neodev").setup()

        -- Setup mason-lspconfig
        require("mason-lspconfig").setup({
            ensure_installed = {
                "clangd",
                "gopls",
                "lua_ls",
                "jdtls"
            },
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,

                -- Custom handler for lua_ls
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,

                -- Custom handler for jdtls (Java)
                ["jdtls"] = function()
                    lspconfig.jdtls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            },
        })

        -- Signature Help UI
        require("lsp_signature").setup({
            bind = true,
            handler_opts = {
                border = "rounded",
            },
            hint_enable = false, -- Disable virtual text hints
        })

        -- Configure diagnostic display
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        -- Define diagnostic signs
        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end,
}
