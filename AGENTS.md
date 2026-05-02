# AGENTS.md - Neovim Configuration

## Common commands

- **Format**: `stylua lua/`
- **Validate**: Open Neovim and run `:checkhealth`
- **Plugins**: `:Lazy sync` to install/update, `:Lazy profile` for performance analysis

## Project structure

- `lua/core/` — options, keymaps, utilities
- `lua/plugins/` — `lazy.nvim` plugin specs, grouped by domain
- `lua/_meta.lua` — type definitions

## Conventions

- Use LuaCATS annotations: `--- @type`, `--- @param`, `--- @return`
- Plugin specs should follow: `return { { "plugin/name", event = "VeryLazy", opts = {} } }`
- Lang specs should follow: `return --- @type LangSpec { lsp = "server", others = { "tool" } }`
- Prefer lazy loading with `event = "VeryLazy"` or `ft = "filetype"`

## Keybinding rules

- Search existing mappings before adding or changing keybindings
- Check `lua/plugins/` and `lua/core/keybind.lua` for conflicts
- Be aware that `on_attach` and `keys` may override mappings based on load order
- Every keybinding must include a clear English description

## General rules

- Avoid excessive searching; stop after 3–4 targeted checks if the approach is not converging
- If the user asks to fix tests, fix the tests instead of the source unless told otherwise
- Do only what is requested
- Prefer editing existing files
- Do not create files unless absolutely necessary
- Do not create documentation files proactively
- Keep memory in the current working directory and `memories/`

## Self-improvement loop

If a `PERSONAL.md` file is present, follow it carefully:

- Review `PERSONAL.md` at the start of every session
- After any correction from the user, update `PERSONAL.md`
- Add rules that prevent the same mistake from recurring
