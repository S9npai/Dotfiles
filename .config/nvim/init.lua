require("config.lazy")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd.colorscheme("S9npai")
    end,
})

vim.opt.number = true
