-- -- Trouble.nvim --
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}
lvim.builtin.which_key.mappings["sr"] = {
  "<cmd>lua require('spectre').open()<cr>", "Search & Replace"
}
lvim.builtin.which_key.mappings["gy"] = {
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  "Open in browser"
}
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

vim.opt.foldmethod = "expr" -- folding set to "expr" for treesitter based folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
vim.opt.foldlevel = 99 -- set to unfold everything by default

-- PLUGINS ---
lvim.plugins = { {
  -- Easy motion like --
  "ggandor/lightspeed.nvim",
  event = "BufRead",
}, {
  -- popup --
  "ray-x/lsp_signature.nvim",
  event = "BufRead",
  config = function()
    require "lsp_signature".setup()
  end
}, {
  -- search & replace --
  "windwp/nvim-spectre",
  event = "BufRead",
  config = function()
    require("spectre").setup()
  end,
}, {
  -- better quickfix window --
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
}, {
  -- markdown tables --
  "dhruvasagar/vim-table-mode"
}, {
  -- easy github links --
  "ruifm/gitlinker.nvim",
  requires = "nvim-lua/plenary.nvim",
}, {
  "tpope/vim-surround",
} }

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } }
}
