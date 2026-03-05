require("nvim-treesitter").setup{
  ensure_installed = { "c", "cpp", "bash", "css", "html", "javascript", "lua", "rust", },

  sync_install = true,

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}
