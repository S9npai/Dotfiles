-- Dashboard using nvimdev/dashboard-nvim
return {
    'nvimdev/dashboard-nvim',

    dependencies = {
        'nvim-tree/nvim-web-devicons', -- Recommended dependency for icons
    },

    config = function()
        -- Define the path to your logo file
        -- NOTE: You will need to create this file, e.g., in the same directory as this config file,
        -- or update the path to point to its location.
        local logo_file_path = vim.fn.stdpath("config") .. "/logos/K8.txt"

        -- Function to read the logo file
        local function read_logo(filepath)
            local f = io.open(filepath, "r")
            if f then
                -- Read the entire file content
                local content = f:read("*a")
                io.close(f)

                -- Split the content by newline to get a table of lines for the header
                -- 'trimempty = true' removes any leading/trailing empty lines if the file has them.
                return vim.split(content, "\n", { plain = true, trimempty = true })
            else
                -- Fallback if the file can't be read (e.g., it doesn't exist)
                print("Error: Could not read logo file at: " .. filepath)
                return { "Nvim", "Dashboard" } -- Default fallback header
            end
        end

        -- Get the header lines from the file
        local custom_header = read_logo(logo_file_path)


        -- The plugin's setup function is called directly with the configuration table.
        require('dashboard').setup({
            -- You can set a theme here, e.g., 'hyper', 'doom', or 'dracula'.
            -- theme = 'doom',
            config = {
                -- 'header' is now the result of reading your custom file
                header = custom_header,

                -- 'center' configures the main buttons (shortcuts).
                center = {
                    { icon = "󰈞 ", desc = "Find File", action = "Telescope find_files", key = "f" },
                    { icon = " ", desc = "New File", action = "ene | startinsert", key = "n" },
                    { icon = " ", desc = "Recent Files", action = "Telescope oldfiles", key = "r" },
                    { icon = " ", desc = "Config", action = "lua LazyVim.pick.config_files()()", key = "c" }, -- Example path from original file
                    { icon = "󰒲 ", desc = "Lazy", action = "Lazy", key = "p" },
                    { icon = "󰐥 ", desc = "Quit", action = "qa", key = "q" },
                },

                -- 'footer' can be a table of strings or a function that returns a table of strings
                -- footer = {'Your custom footer'},
            },
        })
    end
}
