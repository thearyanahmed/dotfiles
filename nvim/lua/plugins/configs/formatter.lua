require("conform").setup {
    formatters_by_ft = {
        lua = {"stylua"},
        -- Conform will run multiple formatters sequentially
        --    python = { "isort", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = {"ast-grep"},
        css = {"prettier"},
        html = {"prettier"},

        sh = {"beautysh"},
        php = {"php"}
    },

    lsp_fallback = true,

    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true
    }
}
