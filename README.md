# Jarmex Nvim

The entire configuration using lua, don't forget to check every plugin
documentation for further information, I think each files is pretty
self-explanatory.

![image](https://github.com/jarmex/nvim/blob/main/baseimage.png?raw=true)

![image](https://github.com/jarmex/nvim/blob/main/ai.png?raw=true)

## Plugin Manager

- [Lazy nvim](https://github.com/folke/lazy.nvim)

<!-- plugins:start -->
## Language support

| Language              | Lsp               | Formatter                      | Linter          | Debugger           | Testing                       |
| --------------------- | ----------------- | ------------------------------ | --------------- | ------------------ | ----------------------------- |
| Lua                   | ✅ luals          | ✅ stylua                      | ❌              | ❌                 | ❌                            |
| C/C++                 | ✅ clangd         | ✅ clangd                      | ✅ clangd       | ✅ codelldb        | ❌                            |
| Java                  | ✅ jdtls          | ✅ jdtls                       | ✅ jdtls        | ✅ jdtls           | ✅ java-test                  |
| JavaScript/TypeScript | ✅ vtsls          | ✅ Biome/prettierd             | ✅ Biome/Eslint | ✅ vscode-js-debug | ✅ neotest-jest/vimtest-mocha |
| Golang                | ✅ gopls          | ✅ gofumpt, goimports, golines | ❌              | ✅ delve           | ✅ neotest-golang             |
| Python                | ✅ Pyright        | ✅ Ruff                        | ✅ Ruff         | ✅ debugpy         | ✅ neotest-python             |
| Markdown              | ✅ marksman       | ✅ prettierd, markdownlint     | ✅ markdownlint | ❌                 | ❌                            |
| HTML                  | ✅ html-lsp       | ✅ prettierd                   | ❌              | ❌                 | ❌                            |
| CSS                   | ✅ css-lsp        | ✅ Biome/prettierd             | ❌              | ❌                 | ❌                            |
| Tailwind CSS          | ✅ tailwindcss-ls | ❌                             | ❌              | ❌                 | ❌                            |
| JSON                  | ✅ jsonls         | ✅ Biome/prettierd             | ❌              | ❌                 | ❌                            |
| TOML                  | ✅ taplo          | ✅ taplo                       | ❌              | ❌                 | ❌                            |
| YAML                  | ✅ yamlls         | ✅ yamlls                      | ❌              | ❌                 | ❌                            |
| Docker                | ✅ dockerls       | ✅ dockerls                    | ✅ hadolint     | ❌                 | ❌                            |

## Keymaps

This config uses [which-key.nvim](https://github.com/folke/which-key.nvim) to display available keymaps
