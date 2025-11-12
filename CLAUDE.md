# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a kickstart.nvim-based Neovim configuration - a well-documented, single-file starter configuration rather than a full distribution. The configuration is primarily optimized for Go development with Lua scripting support.

## Repository Structure

```
init.lua                    # Main configuration file (~1000 lines, well-documented)
lua/
  custom/                   # User customizations (modify these freely)
    plugins/init.lua        # Custom plugin configurations (Go, DAP, persistence, etc.)
    commands.lua            # Custom user commands (testing, formatting)
    snippets.lua            # Custom code snippets
  kickstart/                # Optional kickstart plugins (reference only)
    plugins/               # Additional plugins (debug, lint, neo-tree, etc.)
    health.lua
```

**Important**: The `lua/custom/` directory is for user modifications. The kickstart maintainers promise not to create merge conflicts here.

## Development Commands

### Code Formatting

**Lua formatting:**
```bash
# Uses stylua with config from .stylua.toml
# Format on save is enabled by default
# Manual format: <leader>f in any buffer
```

**Go formatting:**
```bash
# Uses goimports (adds/removes imports) and gofumpt (formatting)
# Format on save is enabled
# Manual format: <leader>f
```

**JSON/XML formatting:**
```vim
:JSONFormat      # Pretty-print JSON
:JSONInline      # Inline JSON
:XMLFormat       # Format XML with xmllint
```

### Testing (Go)

Custom commands for running Go tests from within the editor:

```vim
:TestFunc        # Run the test function under cursor
                 # Searches backwards for 'func TestXxx(t *testing.T)'
                 # Opens in split terminal at the current file's directory

:TestCase        # Run a specific test case (table-driven tests)
                 # Place cursor on test case name
                 # Runs: go test -v -run "^TestFunc$/CaseName$"

:Lint            # Run golangci-lint in current file's directory

:Wire            # Run wire (dependency injection) in current file's directory
```

**Key mapping**: Press `<leader>dt` to debug the Go test under cursor (using nvim-dap-go).

### LSP & Diagnostics

LSP servers are auto-installed via Mason. Currently configured:
- **gopls** (Go) - with completions, unused params analysis
- **lua_ls** (Lua) - for Neovim config development

```vim
:Mason           # View/install LSP servers and tools
:LspInfo         # View active LSP clients
:ConformInfo     # View formatter status
```

### Git Integration

```vim
:LazyGit         # Open lazygit TUI (keymap: <leader>gg)
:DiffviewOpen    # Open diffview for viewing changes
```

### Plugin Management

Plugins are managed by lazy.nvim:

```vim
:Lazy            # Open plugin manager UI
                 # Press 'U' to update, 'I' to install, 'X' to clean
                 # Press '?' for help
```

### Session Management

Sessions are automatically saved via persistence.nvim:

- `<leader>Ss` - Restore session for current directory
- `<leader>Sl` - Restore last session
- `<leader>Sd` - Don't save current session

### Debugging (DAP)

Configured for Go debugging with nvim-dap and nvim-dap-go:

- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dc` - Continue
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>du` - Toggle DAP UI
- `<leader>dh` - Hover variables
- `<leader>dt` - Debug Go test under cursor

## Architecture & Design Patterns

### Single-File Configuration Philosophy

The entire base configuration lives in `init.lua` (~1000 lines). This is intentional for kickstart.nvim:
- Makes it easy to understand the full configuration
- Well-commented for learning
- Users can split it later if desired (see kickstart-modular.nvim)

### Plugin Loading Strategy

Plugins use lazy loading via the lazy.nvim plugin manager:
- Event-based loading (e.g., `event = 'VimEnter'`, `event = 'BufWritePre'`)
- Filetype-based loading (e.g., `ft = { 'go', 'gomod' }`)
- Command-based loading (e.g., `cmd = { 'ConformInfo' }`)

### LSP Configuration Pattern

LSP setup follows a three-layer approach:
1. **mason** - Installs LSP servers, formatters, linters
2. **mason-lspconfig** - Bridges mason and lspconfig
3. **nvim-lspconfig** - Configures and starts language servers

The `LspAttach` autocmd (init.lua:508) is where all LSP keymaps and features are configured per-buffer.

### Custom Plugin Integration

Custom plugins are added in `lua/custom/plugins/init.lua` and returned as a Lua table for lazy.nvim. This keeps custom additions separate from the base kickstart configuration.

### Go Development Enhancements

Two Go plugins work together:
- **go.nvim** - Modern Go development (test runner, coverage, etc.)
- **vim-go** - Mature Go plugin (syntax highlighting, text objects)
  - LSP features disabled to avoid conflicts with gopls through nvim-lspconfig
  - fmt on save disabled (handled by conform.nvim)

### Completion Sources Priority

nvim-cmp completion sources (init.lua:860):
1. lazydev (group_index: 0) - Neovim API completions
2. nvim_lsp - LSP completions
3. luasnip - Snippet completions
4. path - File path completions

## Key Customizations from Base Kickstart

1. **Colorscheme**: Changed from tokyonight to catppuccin (mocha flavor)
2. **Window Navigation**: Arrow keys repurposed for resizing splits (Up/Down/Left/Right)
3. **Buffer Navigation**: `<leader>n` (next), `<leader>p` (previous)
4. **Custom Commands**: Added CopyPath, CopyRelativePath, TestFunc, TestCase
5. **Insert Mode Navigation**: Ctrl+hjkl for movement in insert mode
6. **Completion Keymaps**: Tab/Shift-Tab for completion, Ctrl-n/p for snippet jumping
7. **Telescope Buffers**: Press 'd' or 'dd' to delete buffers from Telescope picker
8. **Save Keymap**: Ctrl+s saves in normal and insert mode

## Mason Tool Installation

The following tools are auto-installed via mason-tool-installer (init.lua:668-683):
- stylua (Lua formatter)
- gopls (Go LSP)
- gofumpt (Go formatter)
- goimports (Go imports)
- golangci-lint (Go linter)
- golangci-lint-langserver (LSP for linting)
- golines (Go line length formatter)
- go-debug-adapter (Go debugger)
- jq (JSON formatter)

## Common Workflows

### Adding a New Plugin

1. Edit `lua/custom/plugins/init.lua`
2. Add plugin spec to the returned table:
   ```lua
   {
     'author/plugin-name',
     config = function()
       require('plugin-name').setup({})
     end,
   }
   ```
3. Restart Neovim or run `:Lazy sync`

### Adding a New LSP Server

1. Edit `init.lua`, find the `servers` table (init.lua:615)
2. Add server configuration:
   ```lua
   servername = {
     settings = {
       -- server-specific settings
     },
   },
   ```
3. Add server name to `ensure_installed` if not auto-detected (init.lua:668)
4. Restart Neovim - Mason will auto-install

### Adding a New Formatter

1. Edit `init.lua`, find `formatters_by_ft` table (init.lua:739)
2. Add filetype and formatter(s):
   ```lua
   python = { 'black', 'isort' },
   ```
3. Add formatter to Mason's `ensure_installed` (init.lua:668)
4. Run `:Mason` to install if needed

### Disabling Auto-format

```vim
:let g:disable_autoformat = 1    " Disable globally
:let b:disable_autoformat = 1    " Disable for current buffer
```

## Troubleshooting

**LSP not working?**
- Run `:LspInfo` to see attached clients
- Run `:Mason` to verify server is installed
- Check `:checkhealth` for issues

**Formatter not working?**
- Run `:ConformInfo` to see available formatters
- Verify tool is in Mason's ensure_installed list

**Plugin not loading?**
- Run `:Lazy` and check for errors (press 'X' to view details)
- Check lazy.nvim logs with `:Lazy log`

**Go test commands not working?**
- Ensure cursor is inside a test function
- For TestCase, cursor must be on the test case name
- Commands change directory to current file's directory before running
