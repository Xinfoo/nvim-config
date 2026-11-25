return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- 安装 parser
        require("nvim-treesitter").install {
            "bash",
            "c",
            "cpp",
            "css",
            "diff",
            "gitcommit",
            "gitignore",
            "html",
            "java",
            "javascript",
            "json",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
        }

        -- 开启语法高亮
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end,
}