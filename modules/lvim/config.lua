-- GENERAL ---
lvim.log.level = "debug"
lvim.lsp.null_ls.setup = {
  log = {
    level = "debug",
  },
}
lvim.format_on_save = true
lvim.colorscheme = "onedarker"
lvim.leader = "space"

lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

lvim.lsp.automatic_servers_installation = true


-- KEYBINDINGS ---
lvim.keys.normal_mode["<S-x>"] = ":BufferClose<CR>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"


-- Trouble.nvim --
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
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', "Open in browser"
}

-- PLUGINS ---
lvim.plugins = {{
  -- Easy motion like --
  "ggandor/lightspeed.nvim",
  event = "BufRead",
}, {
  -- signature popup --
  "ray-x/lsp_signature.nvim",
  event = "BufRead",
  config = function()
    require "lsp_signature".setup()
  end
}, {
  -- signature popup --
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
  "ruifm/gitlinker.nvim",
  requires = "nvim-lua/plenary.nvim",
}}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } }
}
