-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'fatih/vim-go',
    ft = { 'go', 'gomod' },
    build = ':GoUpdateBinaries',
    config = function()
      -- vim-go configuration
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_operators = 1

      -- Disable vim-go's LSP features as we're using gopls through nvim-lspconfig
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_code_completion_enabled = 0

      -- Optional: disable fmt on save (if you prefer to use gofumpt through conform.nvim)
      vim.g.go_fmt_autosave = 0
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
      vim.keymap.set('n', '<leader>dgt', function()
        require('dap-go').debug_test()
      end, { desc = 'Debug Go Test' })
      vim.keymap.set('n', '<leader>dgl', function()
        require('dap-go').debug_last()
      end, { desc = 'Debug Last Go Test' })
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
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      require('dapui').setup()
      -- You can also add key mappings specific to dap-ui if needed
      vim.keymap.set('n', '<leader>du', function()
        require('dapui').toggle()
      end, { desc = 'Toggle DAP UI' })
    end,
  },
  { 'nvim-neotest/nvim-nio' },
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('nvim-dap-virtual-text').setup {
        enabled = true,
        highlight_changed_variables = true,
        show_stop_reason = true,
        commented = true,
      }
    end,
  },
}
