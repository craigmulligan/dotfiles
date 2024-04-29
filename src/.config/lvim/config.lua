lvim.format_on_save = true

-- unbind K so we can map it to tab switches
lvim.lsp.buffer_mappings.normal_mode["K"] = nil
lvim.lsp.buffer_mappings.normal_mode["H"] = { vim.lsp.buf.hover, "Show documentation" }
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
  "<cmd>lua require('spectre').open()<cr>",
  "Search & Replace",
}
lvim.builtin.which_key.mappings["gy"] = {
  '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  "Open in browser",
}

lvim.builtin.dap.active = true
lvim.builtin.which_key.setup.plugins.presets.operators = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.setup.plugins.presets.nav = true
lvim.builtin.which_key.setup.plugins.presets.z = true
lvim.builtin.nvimtree.setup.actions.open_file.resize_window = true
lvim.builtin.nvimtree.setup.view.preserve_window_proportions = true

lvim.builtin.which_key.mappings.s.t = {
  require("telescope").extensions.live_grep_args.live_grep_args,
  "Live grep args",
}

vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.relativenumber = true -- relative line numbers
vim.opt.wrap = true
-- folding powered by treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter#folding
-- look for foldenable: https://github.com/neovim/neovim/blob/master/src/nvim/options.lua
-- Vim cheatsheet, look for folds keys: https://devhints.io/vim
vim.opt.foldmethod = "expr" -- default is "normal"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default is ""
vim.opt.foldenable = true -- if this option is true and fold method option is other than normal, every time a document is opened everything will be folded.
vim.opt.foldlevel = 99

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

local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
}

-- PLUGINS ---
lvim.plugins = {
  {
    -- Easy motion like --
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
  {
    -- better quickfix window --
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    -- markdown tables --
    "dhruvasagar/vim-table-mode",
  },
  {
    -- easy github links --
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "tpope/vim-surround",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "akinsho/git-conflict.nvim",
    version = "v1.0.0",
    config = function()
      require("git-conflict").setup()
    end,
  },
  {
    "yorickpeterse/nvim-pqf",
    config = function()
      require("pqf").setup({
        signs = {
          error = "E",
          warning = "W",
          info = "I",
          hint = "H",
        },
        show_multiple_lines = true,
        -- How long filenames in the quickfix are allowed to be. 0 means no limit.
        -- Filenames above this limit will be truncated from the beginning with [...]
        max_filename_length = 0,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- for name, sign in pairs(Config.icons.dap) do
      --   sign = type(sign) == "table" and sign or { sign }
      --   vim.fn.sign_define(
      --     "Dap" .. name,
      --     { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      --   )
      -- end

      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- Debug single nodejs files
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug nodejs processes (make sure to add --inspect when you run the process)
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
          },
          -- Debug web applications (client side)
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch & Debug Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:3000",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
        }
      end
      if vim.fn.filereadable(".vscode/launch.json") then
        print("Hello, world!")
        local dap_vscode = require("dap.ext.vscode")

        dap_vscode.load_launchjs(nil, {
          ["pwa-node"] = js_based_languages,
          ["chrome"] = js_based_languages,
          ["pwa-chrome"] = js_based_languages,
        })
      end
    end,
    dependencies = {
      -- Install the vscode-js-debug adapter
      {
        "microsoft/vscode-js-debug",
        -- After install, build it and rename the dist directory to out
        build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
        version = "1.*",
      },
      {
        "mxsdev/nvim-dap-vscode-js",
        config = function()
          require("dap-vscode-js").setup({
            -- Path of node executable. Defaults to $NODE_PATH, and then "node"
            -- node_path = "node",
            --
            -- Path to vscode-js-debug installation.
            debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/../lunarvim/site/pack/lazy/opt/vscode-js-debug"),

            -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
            -- debugger_cmd = { "js-debug-adapter" },

            -- which adapters to register in nvim-dap
            adapters = {
              "chrome",
              "pwa-node",
              "pwa-chrome",
              "pwa-msedge",
              "pwa-extensionHost",
              "node-terminal",
            },

            -- Path for file logging
            -- log_file_path = "(stdpath cache)/dap_vscode_js.log",

            -- Logging level for output to file. Set to false to disable logging.
            -- log_file_level = false,

            -- Logging level for output to console. Set to false to disable console output.
            -- log_console_level = vim.log.levels.ERROR,
          })
        end,
      },
    },
  },
}

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { command = "eslint_d", filetypes = { "typescript", "typescriptreact" } },
})
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { exe = "black", filetypes = { "python" } },
  {
    name = "prettier",

    -- these cannot contain whitespace
    -- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
    --@usage only start in these filetypes, by default it will attach to all filetypes it supports
    filetypes = { "typescript", "typescriptreact", "lua" },
  },
})

local lspconfig = require("lspconfig")
lspconfig["tsserver"].setup({
  on_attach = function()
    local function goto_source_definition()
      local position_params = vim.lsp.util.make_position_params()
      vim.lsp.buf.execute_command({
        command = "_typescript.goToSourceDefinition",
        arguments = { vim.api.nvim_buf_get_name(0), position_params.position },
      })
    end
    lvim.lsp.buffer_mappings.normal_mode["gx"] = { goto_source_definition, "Goto source definition" }
  end,
  handlers = {
    ["workspace/executeCommand"] = function(_err, result, ctx, _config)
      if ctx.params.command ~= "_typescript.goToSourceDefinition" then
        return
      end
      if result == nil or #result == 0 then
        return
      end
      vim.lsp.util.jump_to_location(result[1], "utf-8")
    end,
  },
})
