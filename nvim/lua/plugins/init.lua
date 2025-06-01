-- All plugins have lazy=true by default, to load a plugin on startup just set lazy=false
-- List of all default plugins & their definitions
local default_plugins = { -- Utility functions for Neovim
"nvim-lua/plenary.nvim", -- coc.nvim for autocompletion and language server support
{
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false,
    config = function()
        -- This is where you can add configuration for coc.nvim if needed
        -- vim.cmd([[
        --   " Set up basic configuration for coc.nvim
        --   autocmd BufEnter * silent! CocInfo
        -- ]])
    end
}, -- Base46 theme and highlights
{
    "NvChad/base46",
    branch = "v2.0",
    build = function()
        require("base46").load_all_highlights()
    end
}, -- autosave
{
    "Pocco81/auto-save.nvim",

    config = function()
        require("auto-save").setup({
            enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
            execution_message = {
                message = function() -- message to print on save
                    return ("auto saved @ " .. vim.fn.strftime("%H:%M:%S"))
                end,
                dim = 0.18, -- dim the color of `message`
                cleaning_interval = 1250 -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
            },
            trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
            -- function that determines whether to save the current buffer or not
            -- return true: if buffer is ok to be saved
            -- return false: if it's not ok to be saved
            condition = function(buf)
                local fn = vim.fn
                local utils = require("auto-save.utils.data")

                if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
                    return true -- met condition(s), can save
                end
                return false -- can't save
            end,
            write_all_buffers = false, -- write all buffers when the current one meets `condition`
            debounce_delay = 500, -- saves the file at most every `debounce_delay` milliseconds
            callbacks = { -- functions to be executed at different intervals
                enabling = nil, -- ran when enabling auto-save
                disabling = nil, -- ran when disabling auto-save
                before_asserting_save = nil, -- ran before checking `condition`
                before_saving = nil, -- ran before doing the actual save
                after_saving = nil -- ran after doing the actual save
            }
        })
    end,

    lazy = false -- setting this to false makes the plugin load immediately
}, -- NvChad UI components
{
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
    config = function()
        vim.opt.statusline = ""
    end
}, -- Terminal integration for Neovim
{
    "zbirenbaum/nvterm",
    init = function()
        require("core.utils").load_mappings "nvterm"
    end,
    config = function(_, opts)
        require "base46.term"
        require("nvterm").setup(opts)
    end
}, -- Colorizer for highlighting color codes
{
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    config = function(_, opts)
        require("colorizer").setup(opts)

        -- Execute colorizer as soon as possible
        vim.defer_fn(function()
            require("colorizer").attach_to_buffer(0)
        end, 0)
    end
}, -- -- Icons for file types
-- {
--     "nvim-tree/nvim-web-devicons",
--     opts = function()
--         return { override = require "nvchad.icons.devicons" }
--     end,
--     config = function(_, opts)
--         dofile(vim.g.base46_cache .. "devicons")
--         require("nvim-web-devicons").setup(opts)
--     end,
-- },
-- Indentation guides
{
    "lukas-reineke/indent-blankline.nvim",
    version = "2.20.7",
    event = "User FilePost",
    opts = function()
        return require("plugins.configs.others").blankline
    end,
    config = function(_, opts)
        require("core.utils").load_mappings "blankline"
        dofile(vim.g.base46_cache .. "blankline")
        require("indent_blankline").setup(opts)
    end
}, -- Status line plugin
{
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        local cfg = require("plugins.configs.lualine")
        require("plugins.configs.lualine").setup(cfg)
    end
}, -- Treesitter for better syntax highlighting
{
    "nvim-treesitter/nvim-treesitter",
    event = {"BufReadPost", "BufNewFile"},
    cmd = {"TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo"},
    build = ":TSUpdate",
    opts = function()
        return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "syntax")
        require("nvim-treesitter.configs").setup(opts)
    end
}, -- -- Git integration
-- {
--     "lewis6991/gitsigns.nvim",
--     event = "User FilePost",
--     opts = function()
--         return require("plugins.configs.others").gitsigns
--     end,
--     config = function(_, opts)
--         dofile(vim.g.base46_cache .. "git")
--         require("gitsigns").setup(opts)
--     end,
-- },
-- Mason for managing external editor tooling
{
    "williamboman/mason.nvim",
    cmd = {"Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate"},
    opts = function()
        return require "plugins.configs.mason"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "mason")
        require("mason").setup(opts)

        -- Custom NvChad command to install all mason binaries listed
        vim.api.nvim_create_user_command("MasonInstallAll", function()
            if opts.ensure_installed and #opts.ensure_installed > 0 then
                vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
            end
        end, {})

        vim.g.mason_binaries_list = opts.ensure_installed
    end
}, -- LSP configuration
{
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
        require "plugins.configs.lspconfig"
    end
}, -- Autocompletion setup
{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { -- Snippet plugin
    {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = {
            history = true,
            updateevents = "TextChanged,TextChangedI"
        },
        config = function(_, opts)
            require("plugins.configs.others").luasnip(opts)
        end
    }, -- Autopairing of (){}[] etc
    {
        "windwp/nvim-autopairs",
        opts = {
            fast_wrap = {},
            disable_filetype = {"TelescopePrompt", "vim"}
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            -- Setup cmp for autopairs
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    }, -- CMP sources plugins
    {"saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-path"}},
    opts = function()
        return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
        require("cmp").setup(opts)
    end
}, -- Commenting plugin
{
    "numToStr/Comment.nvim",
    keys = {{
        "gcc",
        mode = "n",
        desc = "Comment toggle current line"
    }, {
        "gc",
        mode = {"n", "o"},
        desc = "Comment toggle linewise"
    }, {
        "gc",
        mode = "x",
        desc = "Comment toggle linewise (visual)"
    }, {
        "gbc",
        mode = "n",
        desc = "Comment toggle current block"
    }, {
        "gb",
        mode = {"n", "o"},
        desc = "Comment toggle blockwise"
    }, {
        "gb",
        mode = "x",
        desc = "Comment toggle blockwise (visual)"
    }},
    init = function()
        require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
        require("Comment").setup(opts)
    end
}, -- File managing and picker
{
    "nvim-tree/nvim-tree.lua",
    cmd = {"NvimTreeToggle", "NvimTreeFocus"},
    init = function()
        require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
        return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "nvimtree")
        require("nvim-tree").setup(opts)
    end
}, -- Fuzzy finder
{
    "nvim-telescope/telescope.nvim",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    cmd = "Telescope",
    init = function()
        require("core.utils").load_mappings "telescope"
    end,
    opts = function()
        return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "telescope")
        local telescope = require "telescope"
        telescope.setup(opts)

        -- Load extensions
        for _, ext in ipairs(opts.extensions_list) do
            telescope.load_extension(ext)
        end
    end
}, -- Keybinding helper
{
    "folke/which-key.nvim",
    keys = {"<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g"},
    init = function()
        require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
        dofile(vim.g.base46_cache .. "whichkey")
        require("which-key").setup(opts)
    end
}, -- Code formatter
{
    "stevearc/conform.nvim",
    lazy = false,
    opts = function()
        return require "plugins.configs.formatter"
    end
}, {
    "goolord/alpha-nvim",
    -- dependencies = {'echasnovski/mini.icons'},
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        local startify = require("alpha.themes.startify")
        -- available: devicons, mini, default is mini
        -- if provider not loaded and enabled is true, it will try to use another provider
        startify.file_icons.provider = "devicons"
        require("alpha").setup(startify.config)
    end
}, {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function(_, opts)
        local crates = require('crates')
        crates.setup(opts)
        require('cmp').setup.buffer({
            sources = {{
                name = "crates"
            }}
        })
        crates.show()
    end
}, {
    "github/copilot.vim",
    lazy = false
}, {
    "savq/melange-nvim",
    lazy = false,
    config = function()
        vim.opt.termguicolors = true
        -- vim.o.background = "light"
        -- vim.cmd("colorscheme melange") -- Apply the melange colorscheme
    end
}, {
    "nvim-telescope/telescope.nvim",
    dependencies = {{
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0"
    }},
    config = function()
        local telescope = require("telescope")

        -- first setup telescope
        telescope.setup({
            -- your config
        })

        -- then load the extension
        telescope.load_extension("live_grep_args")
    end
}}

-- Load additional plugins from user configuration if any
local config = require("core.utils").load_config()

if #config.plugins > 0 then
    table.insert(default_plugins, {
        import = config.plugins
    })
end

-- Setup lazy loading for plugins
require("lazy").setup(default_plugins, config.lazy_nvim)
