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


-- -- smart textobjects https://github.com/LunarVim/LunarVim/issues/4298#issuecomment-1647163077
lvim.keys.normal_mode["vaf"] = { ":TSTextobjectSelect @function.outer<cr>", { desc = "Function Outer" } }
lvim.keys.normal_mode["vif"] = { ":TSTextobjectSelect @function.inner<cr>", { desc = "Function Inner" } }
lvim.keys.normal_mode["vac"] = { ":TSTextobjectSelect @class.outer<cr>", { desc = "Class Outer" } }
lvim.keys.normal_mode["vic"] = { ":TSTextobjectSelect @class.inner<cr>", { desc = "Class Outer" } }
lvim.keys.normal_mode["vas"] = { ":TSTextobjectSelect @scope<cr>", { desc = "Language Scope" } }

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


lvim.builtin.dap.active = true
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets.nav = true
lvim.builtin.which_key.setup.plugins.presets.z = true

vim.opt.cmdheight = 2         -- more space in the neovim command line for displaying messages
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true
-- folding powered by treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter#folding
-- look for foldenable: https://github.com/neovim/neovim/blob/master/src/nvim/options.lua
-- Vim cheatsheet, look for folds keys: https://devhints.io/vim
vim.opt.foldmethod = "expr"                     -- default is "normal"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default is ""
vim.opt.foldenable = true -- if this option is true and fold method option is other than normal, every time a document is opened everything will be folded.
vim.opt.foldlevel=99

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
  --- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
    }
  },
  keys = {
    -- normal mode is default
    { "<leader>d", function() require 'dap'.toggle_breakpoint() end },
    { "<leader>c", function() require 'dap'.continue() end },
    { "<C-'>",     function() require 'dap'.step_over() end },
    { "<C-;>",     function() require 'dap'.step_into() end },
    { "<C-:>",     function() require 'dap'.step_out() end },
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = "/Users/craigmulligan/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug",
      adapters = { 'pwa-node' },
    })
    require("dapui").setup()

    for _, language in ipairs({ "typescript", "javascript" }) do
      require("dap").configurations[language] = {
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require 'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        }
      }
    end
    require("dapui").setup()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
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
}, {
  'yorickpeterse/nvim-pqf',
  config = function()
    require('pqf').setup({
      signs = {
        error = 'E',
        warning = 'W',
        info = 'I',
        hint = 'H'
      },
      show_multiple_lines = true,
      -- How long filenames in the quickfix are allowed to be. 0 means no limit.
      -- Filenames above this limit will be truncated from the beginning with [...]
      max_filename_length = 0,
    })
  end
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

-- table.insert(lvim.plugins, {
--   "zbirenbaum/copilot-cmp",
--   event = "InsertEnter",
--   dependencies = { "zbirenbaum/copilot.lua" },
--   config = function()
--     vim.defer_fn(function()
--       require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
--       require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
--     end, 100)
--   end,
-- })
