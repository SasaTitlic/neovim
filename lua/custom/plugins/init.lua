-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup {
        test_runner = 'go',
        run_in_floaterm = true,
        floaterm = true,
        trouble = true,
      }
    end,
    ft = { 'go', 'gomod' }, -- Lazy loaded only for Go files
    build = ':lua require("go.install").update_all_sync()',
  },
  -- Note: vim-go removed - go.nvim provides all needed features including :GoAddTest
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    ft = { 'rust' },
    config = function()
      vim.g.rustaceanvim = {
        tools = {},
        server = {
          on_attach = function(client, bufnr)
            -- Use the same keymaps defined in LspAttach autocmd
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                command = 'clippy',
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        dap = {},
      }
    end,
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'), -- directory where session files are saved
      options = { 'buffers', 'curdir', 'tabpages', 'winsize' }, -- sessionoptions used for saving
      pre_save = nil, -- a function to call before saving the session
      save_empty = false, -- don't save if there are no open file buffers
    },
    keys = {
      {
        '<leader>Ss',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>Sl',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>Sd',
        function()
          require('persistence').stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter', -- Lazy load only when entering insert mode
    opts = {
      fast_wrap = {},
      disable_filetype = { 'TelescopePrompt', 'vim' },
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      -- Configure codelldb for Rust debugging
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.rust = {
        {
          name = 'Launch Rust',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
        {
          name = 'Attach to Rust process',
          type = 'codelldb',
          request = 'attach',
          pid = function()
            return tonumber(vim.fn.input 'PID: ')
          end,
          cwd = '${workspaceFolder}',
        },
      }

      -- Add your custom key mappings here
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step Over' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
      -- Key mapping for setting a conditional breakpoint with <leader>dB
      vim.keymap.set('n', '<leader>dB', function()
        -- Prompt the user for a condition and set the conditional breakpoint
        vim.ui.input({ prompt = 'Condition: ' }, function(condition)
          if condition then
            require('dap').set_breakpoint(condition)
          end
        end)
      end, { desc = 'Set Conditional Breakpoint' })

      -- Hovering over values
      vim.keymap.set('n', '<leader>dh', function()
        require('dap.ui.widgets').hover()
      end, { desc = 'Hover Variables' })
      vim.keymap.set('n', '<leader>dt', function()
        require('dap-go').debug_test()
      end, { desc = 'Debug Go Test' })
      -- Rust test debugging with rustaceanvim
      vim.keymap.set('n', '<leader>dr', function()
        vim.cmd.RustLsp('testables')
      end, { desc = 'Debug [R]ust Test' })
    end,
  },
  {
    'leoluz/nvim-dap-go',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dap-go').setup()
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true, -- Lazy load until first use via keymaps
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dapui = require 'dapui'

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        element_mappings = {},
        expand_lines = true,
        force_buffers = true,
        floating = {
          max_height = nil,
          max_width = nil,
          border = 'single',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        controls = {
          enabled = true,
          element = 'repl',
          icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            run_last = '',
            terminate = '',
          },
        },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
          indent = 1,
        },
        layouts = {
          { -- Layout 1: scopes on the side
            elements = {
              { id = 'scopes', size = 1.0 },
            },
            size = 40,
            position = 'right',
          },
          { -- Layout 2: repl at the bottom
            elements = {
              { id = 'repl', size = 1.0 },
            },
            size = 10,
            position = 'bottom',
          },
        },
      }

      vim.keymap.set('n', '<leader>du', function()
        dapui.toggle()
      end, { desc = 'Toggle DAP UI' })
    end,
  },
  -- Note: nvim-nio already loaded as dependency of nvim-dap-ui, standalone entry removed
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- Note: gitsigns.nvim already configured in init.lua, duplicate removed
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup {
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = 'diff2_horizontal',
          },
        },
      }
    end,
  },
  {
    'kdheepak/lazygit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { silent = true, desc = 'LazyGit' })
    end,
  },
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      terminal = {
        split_side = 'right',
        split_width_percentage = 0.40,
      },
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
      },
    },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Model' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection' },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
}
