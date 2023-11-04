lvim.format_on_save = true

-- unbind K so we can map it to tab switches
lvim.lsp.buffer_mappings.normal_mode['K'] = nil
lvim.lsp.buffer_mappings.normal_mode['H'] = { vim.lsp.buf.hover, "Show documentation" }
lvim.keys.insert_mode["jk"] = "<ESC>"
lvim.keys.normal_mode["<S-j>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-k>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

-- -- unbind default nav ---
lvim.keys.normal_mode["<M-h>"] = "<C-w>h"
lvim.keys.normal_mode["<M-j>"] = "<C-w>j"
lvim.keys.normal_mode["<M-k>"] = "<C-w>k"
lvim.keys.normal_mode["<M-l>"] = "<C-w>l"

-- show dotfiles
lvim.builtin.nvimtree.setup.filters.dotfiles = false

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


-- lvim.builtin.dap.active = true
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets.nav = true

vim.opt.wrap = true
vim.opt.foldmethod = "expr"                     -- folding set to "expr" for treesitter based folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
vim.opt.foldlevel = 99                          -- set to unfold everything by default

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- PLUGINS ---
lvim.plugins = { {
  -- Easy motion like --
  "ggandor/lightspeed.nvim",
  event = "BufRead",
}, {
  "mxsdev/nvim-dap-vscode-js",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = "/home/hobochild/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug",  -- Path to vscode-js-debug installation.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      require("dap").configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Debug Jest Tests",
          -- trace = true, -- include debugger info
          runtimeExecutable = "node",
          runtimeArgs = {
            "./node_modules/.bin/react-scripts",
            "test",
          },
          rootPath = "${workspaceFolder}",
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require 'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        }
      }
    end
  end
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
  dependencies = "nvim-lua/plenary.nvim",
}, {
  "tpope/vim-surround",
}, {
  "nvim-treesitter/nvim-treesitter-textobjects",
  after = "nvim-treesitter",
  dependencies = "nvim-treesitter/nvim-treesitter",
}, {
  'akinsho/git-conflict.nvim',
  version = "*",
  config = true
} }



local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "eslint_d", filetypes = { "typescript", "typescriptreact" } }
}
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { exe = "black", filetypes = { "python" } },
  {
    name = "prettier",

    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    --@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact", "lua" },
  },
}
