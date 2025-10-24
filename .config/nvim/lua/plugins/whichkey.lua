-- lua/plugins/whichkey.lua

return {
    'folke/which-key.nvim',
    -- 1. Force load on startup as requested
    lazy = false,
    priority = 1000,
    init = function()
        -- Set leader key to space (best practice is often to set this in init.lua)
        vim.g.mapleader = ' '
        vim.g.maplocalleader = '\\'
    end,

    opts = {
        -- Basic setup options for which-key
        -- This ensures it starts up correctly
    },

    -- 2. Define keymaps using the 'keys' table (preferred lazy.nvim method)
    keys = {
        { '<C-s>',      '<cmd>write<cr>',                       desc = '[W]rite/Save File' },
        { '<S-t>',      '<cmd>belowright split | terminal<cr>', desc = '[T]oggle terminal' },

        -- Group: Find (f)
        { '<leader>f',  group = '[F]ind' },
        { '<leader>ff', '<cmd>Telescope find_files<cr>',        desc = '[F]ind [F]iles' },
        { '<leader>fg', '<cmd>Telescope live_grep<cr>',         desc = '[F]ind by [G]rep' },
        { '<leader>fb', '<cmd>Telescope buffers<cr>',           desc = '[F]ind [B]uffers' },
        { '<leader>fh', '<cmd>Telescope help_tags<cr>',         desc = '[F]ind [H]elp' },

        -- Group: LSP/Code (l)
        { '<leader>l',  group = '[L]SP/Code' },
        { '<leader>ld', vim.lsp.buf.definition,                 desc = 'Go to [D]efinition' },
        { '<leader>lr', vim.lsp.buf.references,                 desc = 'Go to [R]eferences' },
        { '<leader>ln', vim.lsp.buf.rename,                     desc = '[R]e[n]ame Symbol' },
        { '<leader>la', vim.lsp.buf.code_action,                desc = 'Code [A]ction' },

        -- Group: Theme (t)
        { '<leader>t',  group = '[T]hemes' },
        { '<leader>tc', '<cmd>Telescope colorscheme<cr>',       desc = '[C]hange Theme' },
    },

    config = function(_, opts)
        -- The actual setup call
        require('which-key').setup(opts)
    end,
}
