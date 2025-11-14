# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on kickstart.nvim, customized for Go development with extensive LSP, debugging, and Git integration. The configuration uses lazy.nvim as the plugin manager and is primarily focused on Go development workflows.

## Configuration Architecture

### Core Structure

- **init.lua**: Main configuration file containing base settings, keymaps, and plugin setup via lazy.nvim
- **lua/custom/commands.lua**: Custom user commands (XML/JSON formatting, Go test runners, Wire, linting)
- **lua/custom/plugins/init.lua**: Additional plugin configurations beyond the kickstart defaults
- **lua/custom/snippets.lua**: Custom LuaSnip snippets (primarily Go-focused)
- **lua/kickstart/plugins/**: Optional kickstart plugin modules (neo-tree, debug, lint, etc.)

### Plugin Manager

Uses lazy.nvim for plugin management. Key commands:
- `:Lazy` - View plugin status
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Install/update/clean plugins

Plugins are loaded from:
1. Main init.lua (core plugins)
2. lua/custom/plugins/*.lua (custom additions via `{ import = 'custom.plugins' }`)
3. Required kickstart plugins (e.g., `require 'kickstart.plugins.neo-tree'`)

### LSP Configuration

LSP servers are managed through Mason. Configured servers:
- **gopls**: Go language server with completeUnimported, usePlaceholders, and analysis features
- **lua_ls**: Lua language server configured for Neovim development

Tools installed via mason-tool-installer:
- gopls, lua_ls, stylua, gofumpt, goimports, golangci-lint (pinned to v1.64.5)

### Formatting

Uses conform.nvim for code formatting with format-on-save enabled (unless disabled via `vim.g.disable_autoformat` or `vim.b.disable_autoformat`).

Formatters by filetype:
- **lua**: stylua
- **go**: gofumpt, goimports-reviser
- **json**: jq (with 2-space indent)

## Key Custom Commands

### Go Development

- **:TestFunc** - Run the Go test function under cursor (searches backwards for `func TestXxx(t *testing.T)`)
- **:TestCase** - Run specific test case within a table-driven test (uses word under cursor)
- **:Wire** - Run Wire dependency injection in current file's directory
- **:Lint** - Run golangci-lint in current file's directory

### Formatting Utilities

- **:XMLFormat** - Format XML using xmllint
- **:JSONFormat** - Format JSON using jq with pretty-print
- **:JSONInline** - Format JSON as single line using jq -c

### File Path Utilities

- **:CopyPath** - Copy absolute path of current buffer to clipboard
- **:CopyRelativePath** - Copy relative path of current buffer to clipboard

## Debugging Setup

nvim-dap is configured with nvim-dap-go for Go debugging support.

Key debug mappings (all prefixed with `<leader>d`):
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint (prompts for condition)
- `<leader>dc` - Continue execution
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dh` - Hover to inspect variables
- `<leader>dt` - Debug current Go test
- `<leader>du` - Toggle DAP UI

## Custom Keymaps

### Leader Key

Space is configured as the leader key (`vim.g.mapleader = ' '`).

### Buffer/Window Navigation

- `<leader>n` / `<leader>p` - Next/Previous buffer
- `<leader><leader>` - Telescope buffer picker
- `<leader>xb` - Close current buffer
- `<leader>xt` - Close current tab
- `<C-h/j/k/l>` - Navigate between windows

### Window Resizing

- Arrow keys - Resize windows (Up/Down for height, Left/Right for width)
- `<S-Up>` - Equalize window sizes

### Telescope Search

- `<leader>sf` - Find files
- `<leader>sg` - Live grep
- `<leader>sw` - Search word under cursor
- `<leader>s/` - Live grep in open files
- `<leader>sn` - Search Neovim config files
- `<leader>sc` - Search command history

### Git Integration

- `<leader>gg` - Open LazyGit

### Claude Code Integration

The claudecode.nvim plugin is configured with keymaps under `<leader>a`:
- `<leader>ac` - Toggle Claude Code
- `<leader>af` - Focus Claude Code terminal
- `<leader>ar` - Resume previous session
- `<leader>ab` - Add current buffer to context
- `<leader>as` - Send visual selection (visual mode)
- `<leader>aa` / `<leader>ad` - Accept/Deny diff

## Go-Specific Features

### Plugins

- **ray-x/go.nvim**: Enhanced Go development features
- **fatih/vim-go**: Additional Go syntax highlighting (LSP features disabled to avoid conflicts with gopls)

### Test Workflow

When writing/debugging Go tests:
1. Position cursor inside a test function
2. Use `:TestFunc` to run just that test in a split terminal
3. For table-driven tests, position cursor on test case name and use `:TestCase`
4. For debugging, use `<leader>dt` to launch debugger on current test

### Formatting Workflow

Files are automatically formatted on save. To disable:
- Globally: `vim.g.disable_autoformat = true`
- Per-buffer: `vim.b.disable_autoformat = true`

Manual format: `<leader>f`

## Session Management

persistence.nvim is configured for session persistence:
- `<leader>Ss` - Restore session for current directory
- `<leader>Sl` - Restore last session
- `<leader>Sd` - Don't save current session

## Color Scheme

Uses Catppuccin with the "macchiato" flavor. Available flavors: mocha, macchiato, frappe (dark themes), latte (light theme).

## Important Notes

- Copilot tab mapping is disabled (`vim.g.copilot_no_tab_map = true`)
- Tab width is set to 4 spaces
- Relative line numbers are enabled
- Clipboard is synced with OS (`clipboard = 'unnamedplus'`)
- golangci-lint is pinned to v1.64.5 to avoid compatibility issues
