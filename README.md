# Jack's Neovim Configuration

A modern, well-documented Neovim setup focused on intuitive defaults and discoverability.

## Features

- **🔍 Telescope** - Fuzzy find files, text, and everything else
- **📁 Neo-tree** - File explorer with git integration
- **🎯 Harpoon** - Lightning-fast navigation between key files
- **🧠 LSP** - Full IDE features with auto-installing language servers
- **✨ Blink.cmp** - Fast, modern completion
- **🌳 Treesitter** - Advanced syntax highlighting
- **🔀 Gitsigns** - Git integration in the gutter
- **❓ Which-key** - Discover keybindings as you type
- **🤖 Kiro** - AI assistant integrated via ACP
- **🎨 Catppuccin** - Beautiful, easy-on-the-eyes theme

## Quick Start

See [QUICKSTART.md](./QUICKSTART.md) for detailed setup and learning guide.

### Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Create symlink
ln -s ~/nvim-config-2026 ~/.config/nvim

# Launch Neovim (plugins will auto-install)
nvim
```

## Structure

```
nvim-config-2026/
├── init.lua              # Entry point
├── lua/
│   ├── config/
│   │   ├── settings.lua  # Core Neovim settings
│   │   └── lazy.lua      # Plugin manager setup
│   └── plugins/          # Plugin configurations
│       ├── theme.lua
│       ├── telescope.lua
│       ├── neotree.lua
│       ├── harpoon.lua
│       ├── treesitter.lua
│       ├── lsp.lua
│       ├── blink.lua
│       ├── gitsigns.lua
│       ├── whichkey.lua
│       ├── kiro.lua
│       └── extras.lua
├── QUICKSTART.md         # Learning guide
└── README.md             # This file
```

## Key Bindings

Leader key: `Space`

### Most Important

- `<leader>ff` - Find files
- `<leader>sg` - Search text (grep)
- `<leader>e` - Toggle file explorer
- `<leader>a` - Add file to harpoon
- `<leader>h` - Toggle harpoon menu
- `Ctrl+\` - Toggle Kiro AI chat

See [QUICKSTART.md](./QUICKSTART.md) for complete keybinding reference.

## Customization

All configuration is in plain Lua files with extensive comments. To customize:

1. Edit files in `lua/config/` for core settings
2. Edit files in `lua/plugins/` for plugin-specific config
3. Restart Neovim

## Philosophy

This config prioritizes:

1. **Intuitive defaults** - Works great out of the box
2. **Discoverability** - Which-key helps you learn
3. **Documentation** - Every file is well-commented
4. **Simplicity** - Easy to understand and modify
5. **Modern tools** - Uses current best practices

## Requirements

- Neovim >= 0.10
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `ripgrep` (for telescope grep)
- `make` (for telescope-fzf-native)

## Troubleshooting

Run `:checkhealth` to diagnose issues.

Common commands:
- `:Lazy` - Plugin manager
- `:Mason` - LSP installer
- `:LspInfo` - LSP status
- `:Telescope keymaps` - Search all keybindings

## License

MIT - Feel free to use and modify!
