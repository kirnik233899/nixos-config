local colors = {
  base00 = "#000000",
  base01 = "#231a40",
  base02 = "#432d59",
  base03 = "#593380",
  base04 = "#7b43bf",
  base05 = "#b08ae6",
  base06 = "#9045e6",
  base07 = "#a366ff",
  base08 = "#a82ee6",
  base09 = "#bb66cc",
  base0A = "#f29df2",
  base0B = "#41d9bf",
  base0C = "#40dfff",
  base0D = "#326ee6",
  base0E = "#7e5ce6",
  base0F = "#a886bf",
}

return {
  { "RRethy/base16-nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("base16-colorscheme").setup(colors)
      end,
    },
  },
}
