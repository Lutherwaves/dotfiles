# Dotfiles

Personal dotfiles and configuration files for an AI-powered development environment setup.

## Overview

This repository contains configuration files for various tools and applications used in my development workflow, including shell configuration, terminal multiplexer, text editor, AI coding assistants, and other development tools. The setup is designed to work out of the box - simply clone and run the installation script.

## Installation

### Quick Install

The easiest way to set up this development environment:

```bash
# Clone the repository
git clone https://github.com/Lutherwaves/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installation script (handles everything automatically)
./install.sh
```

The installation script will:
- Clone the repository if not already present
- Install system dependencies (tmux, node, git, etc.)
- Set up AI coding agents (Claude Code, Cursor CLI, etc.)
- Configure tmux with plugin manager
- Set up shell configuration (.zshrc)
- Create necessary directories and environment files
- Verify the installation

### Manual Installation

If you prefer to set up manually:

```bash
# Clone the repository
git clone https://github.com/Lutherwaves/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the setup script
./scripts/setup.sh

# Reload your shell configuration
source ~/.zshrc
```

## What's Included

### Shell Configuration
- **`.zshrc`** - Zsh shell configuration with aliases, functions, AI agent helpers, and environment setup

### Terminal & Multiplexer
- **`.config/tmux/`** - Tmux configuration files for session management and layouts (including AI development layouts)
- **`.config/kitty/`** - Kitty terminal emulator configuration

### Text Editor
- **`.config/nvim/`** - Neovim configuration with LazyVim setup

### AI Development Tools
- **`.cursor/`** - Cursor IDE configuration, rules, and MCP setup
- **`.claude/`** - Claude AI coding assistant configuration and rules

### Development Tools
- **`.gitconfig`** - Git configuration and aliases

### Scripts
- **`install.sh`** - Main one-line installation script (recommended)
- **`scripts/setup.sh`** - Complete setup script for AI development environment
- **`scripts/backup.sh`** - Configuration backup utility
- **`scripts/install_agents.sh`** - AI agent installation helper
- **`scripts/setup_mcp.sh`** - MCP server setup

## Repository Structure

```
.
├── .zshrc                 # Main shell configuration
├── .gitconfig             # Git configuration
├── .config/
│   ├── nvim/             # Neovim configuration
│   ├── tmux/             # Tmux configuration
│   └── kitty/            # Kitty terminal configuration
├── .cursor/              # Cursor IDE configuration
├── .claude/              # Claude AI configuration
├── scripts/              # Setup and utility scripts
├── install.sh            # Main installation script
└── README.md             # This file
```

## Post-Installation Setup

After running the installation script, you'll need to:

1. **Reload your shell configuration:**
   ```bash
   source ~/.zshrc
   ```

2. **Configure API keys** (if using AI agents):
   Edit `~/.ai-env` and add your API keys:
   ```bash
   export ANTHROPIC_API_KEY="your-claude-api-key"
   export CURSOR_API_KEY="your-cursor-api-key"
   ```

3. **Authenticate with AI agents:**
   ```bash
   claude login
   cursor-agent login
   ```

4. **Start your first AI session:**
   ```bash
   dev-ai claude
   ```

## Customization

These dotfiles are tailored to my personal preferences and workflow. Feel free to fork this repository and customize it to your needs.

### Key Customization Points

1. **Shell Aliases** - Modify `.zshrc` to add or change aliases and functions
2. **Editor Settings** - Adjust Neovim configuration in `.config/nvim/`
3. **Terminal Setup** - Customize tmux layouts and kitty configurations
4. **Git Configuration** - Update `.gitconfig` with your details
5. **AI Agent Rules** - Customize Cursor and Claude rules in `.cursor/` and `.claude/`

## Requirements

- **Zsh shell** (default on macOS, install with `sudo apt install zsh` on Linux)
- **Git** (for cloning and version control)
- **Node.js and npm** (for AI agent installation)
- **Neovim** (for editor configuration - will be installed if missing)
- **Tmux** (for terminal multiplexer - will be installed if missing)
- **Kitty** (optional, for terminal emulator configuration)

The installation script will automatically install missing dependencies on Linux (apt) and macOS (Homebrew).

## Usage

After installation, the following commands are available:

- `dev-ai <agent>` - Start an AI coding session (e.g., `dev-ai claude`)
- `ai-agent help` - Get help with AI agent commands
- Various shell aliases and functions defined in `.zshrc`

For tmux layouts:
- `tmux new-session -s ai -f ~/.config/tmux/ai-layout.conf` - Start AI development layout
- `tmux new-session -s dev -f ~/.config/tmux/dev-layout.conf` - Start development layout

## Backup

To backup your current configurations before installing:

```bash
./scripts/backup.sh
```

## Maintenance

To update your dotfiles:

```bash
cd ~/.dotfiles
git pull
./scripts/setup.sh
```

Or if you used the default installation location:

```bash
cd ~/.dotfiles && git pull && ./scripts/setup.sh
```

## Contributing

While these are personal dotfiles, suggestions and improvements are welcome. Please feel free to open an issue or submit a pull request on [GitHub](https://github.com/Lutherwaves/dotfiles).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Repository

- **GitHub:** https://github.com/Lutherwaves/dotfiles
- **Issues:** https://github.com/Lutherwaves/dotfiles/issues
- **Pull Requests:** https://github.com/Lutherwaves/dotfiles/pulls

## Acknowledgments

- Inspired by various dotfiles repositories in the community
- Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim)
- Tmux plugin manager from [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- Thanks to all the open-source tool maintainers
