return {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    background="soft",
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    
    config = function (plugin, opts)
      require('everforest').setup(opts)
  
      vim.cmd('colorscheme everforest')
    end
}