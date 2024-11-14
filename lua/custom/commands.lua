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

  vim.api.nvim_create_user_command('TestFunc', function()
    -- Search backwards for the test function definition
    local current_line = vim.fn.line '.'
    local test_func = nil

    for i = current_line, 1, -1 do
      local line = vim.fn.getline(i)
      local match = string.match(line, 'func%s+([^%(]+)%(t%s*%*testing%.T%)')
      if match then
        test_func = match
        break
      end
    end

    if test_func then
      -- Get current file's directory
      local current_dir = vim.fn.expand '%:p:h'
      -- Change to the directory and run the test
      local cmd = string.format('split | lcd %s | terminal go test -v -run "^%s$" .', current_dir, test_func)
      vim.cmd(cmd)
      vim.cmd 'startinsert'
    else
      vim.notify("No test function found. Make sure you're inside a test function.", vim.log.levels.WARN)
    end
  end, {})

  -- Command to run specific test case (also fixed to use current directory)
  vim.api.nvim_create_user_command('TestCase', function()
    local case_name = vim.fn.expand '<cword>'
    local current_line = vim.fn.line '.'
    local test_func = nil

    for i = current_line, 1, -1 do
      local line = vim.fn.getline(i)
      local match = string.match(line, 'func%s+([^%(]+)%(t%s*%*testing%.T%)')
      if match then
        test_func = match
        break
      end
    end

    if test_func and case_name then
      local current_dir = vim.fn.expand '%:p:h'
      local cmd = string.format('split | lcd %s | terminal go test -v -run "^%s$/%s$" .', current_dir, test_func, case_name)
      vim.cmd(cmd)
      vim.cmd 'startinsert'
    else
      vim.notify("No test function/case found. Make sure you're inside a test function and cursor is on a test case name.", vim.log.levels.WARN)
    end
  end, {})
end

return M
