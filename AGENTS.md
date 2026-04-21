# AGENTS.md - Neovim Configuration

## Commands

- **Format**: `stylua lua/` (format Lua files)
- **Validate**: Open Neovim and run `:checkhealth`
- **Plugins**: `:Lazy sync` (install/update), `:Lazy profile` (performance)

## Structure

- `lua/core/` - Options, keymaps, utilities
- `lua/plugins/` - lazy.nvim plugin specs (grouped by domain)
- `lua/_meta.lua` - Type definitions

## Patterns

- Use LuaCATS annotations: `--- @type`, `--- @param`, `--- @return`
- Plugin specs: `return { { "plugin/name", event = "VeryLazy", opts = {} } }`
- Lang specs: `return --- @type LangSpec { lsp = "server", others = { "tool" } }`
- Prefer `event = "VeryLazy"` or `ft = "filetype"` for lazy loading

## Keybinding Guidelines

- **Before adding/modifying keybindings**: Search the codebase for existing uses of the key sequence to avoid conflicts
- **Check for conflicts**: Use `grep` to search `lua/plugins/` and `lua/core/keybind.lua` for the key pattern
- **Avoid overwriting**: Plugin keybindings in `on_attach` or `keys` tables may override each other based on load order
- **All keybindings need descriptions**: Ensure every keybinding has a clear description for better usability and maintenance (english only)

## General rules

- Don't over-explore the codebase with excessive grep/read calls. If you haven't converged on an approach after 3-4 searches, pause and share what you've found so far rather than continuing to search.
- When the user asks to fix tests, fix the tests — not the source code — unless explicitly asked otherwise.

## Important instructions

- Do what has been asked; nothing more, nothing less.
- NEVER create files unless absolutely necessary
- ALWAYS prefer editing existing files
- NEVER proactively create documentation files
- ALWAYS keep memory in the current working directory and `memories/` folder

### Self-improvement loop

The user may have shared a `PERSONAL.md` file with specific instructions for how they like to work. If so, follow these instructions carefully:

- Review the `PERSONAL.md` at the start of every session
- After ANY correction from the user: update the `PERSONAL.md` with the pattern
- Write rules that prevent the same mistake from happening again
