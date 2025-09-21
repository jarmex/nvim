# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a sophisticated Neovim configuration with extensive plugin customization, AI integrations, and comprehensive language support. The configuration uses lazy.nvim as the plugin manager and follows a modular architecture.

## Common Commands

### Plugin Management
- **Update plugins**: Open Neovim and run `:Lazy sync`
- **Check plugin status**: `:Lazy`
- **Profile startup time**: `:Lazy profile`

### Code Formatting and Linting
- **Format Lua files**: `stylua .` (uses stylua.toml configuration)
- **Lint Lua files**: `selene .` (uses selene.toml configuration)
- **Format current buffer in Neovim**: `<leader>cf` (configured formatter per filetype)
- **Lint current buffer**: Automatic via nvim-lint on save/insert leave

### Development Workflow
- **Run tasks**: `:OverseerRun` (custom templates in lua/overseer/)
- **Toggle terminal**: `<C-/>` or `<leader>tt`
- **Git operations**: `:Neogit` or `<leader>gg`
- **AI assistance**: `<leader>cc` (CodeCompanion chat), `<leader>ca` (inline assist)

## Architecture

### Core Structure
```
nvim/
├── init.lua                 # Entry point - sets globals and requires config
├── lua/config/             # Core configuration modules
│   ├── init.lua           # Main loader - initializes everything
│   ├── lazy.lua           # Plugin manager configuration
│   └── [options|keymaps|commands|autocmds].lua
├── lua/plugins/           # Plugin configs organized by category
│   ├── ai/               # AI tools (CodeCompanion, Copilot, etc.)
│   ├── coding/           # LSP, DAP, formatters, linters
│   └── [other categories]
└── lua/helpers/          # Utility modules (lazy-loaded via metatable)
```

### Key Design Patterns

1. **Lazy Loading**: Plugins are loaded on-demand using lazy.nvim's event system. Common events:
   - `LazyFile`: Custom event for file-related operations
   - `VeryLazy`: For UI elements that can load after startup
   - Command/key-based loading for tools

2. **Modular Plugin Configuration**: Each plugin has its own file in `lua/plugins/`. Complex plugins may have sub-modules (e.g., `ai/codecompanion/` contains adapters.lua, extensions.lua, etc.)

3. **Global Configuration**: Key settings in init.lua:
   - `vim.g.borderStyle`: Controls UI border style ("rounded", "single", "double")
   - `vim.g.linterConfigs`: Per-language linter configurations
   - `vim.g.cmpLoader`: Controls completion engine loading

4. **Helper System**: Helpers are accessed via `_G.helpers` and lazy-loaded on first access. Available modules:
   - `helpers.lsp`: LSP utilities and on_attach handler
   - `helpers.colors`: Color manipulation utilities
   - `helpers.icons`: Consistent icon definitions
   - `helpers.utils`: General utility functions

### AI Integration Architecture

The configuration heavily integrates AI tools, particularly CodeCompanion:
- Custom adapters for various AI providers (OpenAI, Anthropic, Google, etc.)
- Extensive prompt library and slash commands
- Tools integration for code analysis and generation
- Custom system prompts for better context

### Language Support

Comprehensive LSP configurations in `lua/plugins/coding/lspconfig.lua`:
- Auto-installs language servers via Mason
- Per-language server configurations
- Formatters and linters configured per filetype
- DAP (debugging) support for major languages

## Important Conventions

1. **File Organization**: Place new plugins in the appropriate category under `lua/plugins/`
2. **Lazy Loading**: Always consider lazy loading for performance
3. **Keymaps**: Leader key is Space; follow existing patterns (e.g., `<leader>c*` for code actions)
4. **LSP Integration**: Use `helpers.lsp.on_attach` for consistent LSP keybindings
5. **Border Styling**: Use `vim.g.borderStyle` for consistent UI borders
6. **AI Prompts**: Custom prompts are in `lua/plugins/ai/codecompanion/extensions.lua`

## Testing and Debugging

- **Run tests**: Use neotest (`<leader>nt` prefix) or Overseer templates
- **Debug code**: DAP configured with `<leader>d` prefix keymaps
- **Profile performance**: `:Lazy profile` for startup times
- **Check health**: `:checkhealth` for diagnostics

## Git Workflow

The repository uses git with features:
- Pre-commit hooks available via Overseer (`:OverseerRun git pre-commit`)
- Neogit for comprehensive git operations
- Diffview for advanced diff viewing
- Git blame integration