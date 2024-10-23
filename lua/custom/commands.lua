local M = {}

function M.setup()
  -- XML formatting command
  vim.api.nvim_create_user_command('XMLFormat', function()
    vim.cmd '%!xmllint --format -'
  end, {})

  -- JSON formatting command
  vim.api.nvim_create_user_command('JSONFormat', function()
    vim.cmd '%!jq "."'
  end, {})

  -- JSON inline formatting command
  vim.api.nvim_create_user_command('JSONInline', function()
    vim.cmd '%!jq -c "."'
  end, {})

  -- Wire command
  vim.api.nvim_create_user_command('Wire', function()
    vim.cmd '!cd %:h && wire'
  end, {})

  -- Lint command
  vim.api.nvim_create_user_command('Lint', function()
    vim.cmd '!cd %:h && golangci-lint run'
  end, {})
end

return M
