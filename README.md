# AI Development Environment Setup

This repository contains dotfiles for a portable AI development environment with support for multiple AI coding agents, tmux remote development, and cross-platform compatibility.

## Features

- **Multi-Agent Support**: Claude Code, Cursor CLI, OpenCode with easy switching
- **Tmux Remote Development**: Persistent sessions for remote work via Tailscale
- **Cross-Platform**: Works on macOS and Linux
- **Agent Protocol Support**: ACP (Agent Client Protocol) compatible

## Quick Setup

```bash
# Clone dotfiles
git clone https://github.com/Lutherwaves/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run setup script
./scripts/setup.sh

# Reload shell
source ~/.zshrc
```

## AI Agents

### Claude Code
```bash
# Install
npm install -g @anthropic-ai/claude-code

# Authenticate
claude login

# Use
claude                    # Direct Claude Code
clauder                   # Claude Code via CCR (router)
```

### Cursor CLI + ACP
```bash
# Install Cursor CLI
curl https://cursor.com/install -fsSL | bash

# Authenticate
cursor-agent login

# Install ACP adapter
npm install -g @blowmage/cursor-agent-acp-npm

# Use
ai-agent cursor           # Cursor via ACP
```

### OpenCode
```bash
# Install
npm install -g opencode

# Use
ai-agent opencode         # OpenCode via ACP
```

### Agent Switching
```bash
# Universal agent launcher
ai-agent claude           # Switch to Claude
ai-agent cursor           # Switch to Cursor
ai-agent opencode         # Switch to OpenCode

# Quick aliases
ac                         # Claude Code
ar                         # Cursor via ACP
ao                         # OpenCode via ACP
```

## Tmux Remote Development

### Session Management
```bash
# Create development session
tmux new -s dev-ai

# Create with AI agent
tmux new -s dev-ai 'ai-agent claude'

# List sessions
tmux ls

# Attach to session
tmux attach -t dev-ai

# Detach (keep running)
Ctrl+b d

# Kill session
tmux kill-session -t dev-ai
```

### Remote Access via Tailscale
```bash
# From client machine
ssh user@machine-ip -t "tmux attach -t dev-ai"

# Or create dedicated remote session
tmux new -s remote-dev 'ai-agent cursor'
```

### Essential Tmux Shortcuts
- `Ctrl+b c` - Create new window
- `Ctrl+b %` - Split vertical
- `Ctrl+b "` - Split horizontal
- `Ctrl+b ←/→/↑/↓` - Navigate panes
- `Ctrl+b d` - Detach session
- `Ctrl+b 0-9` - Switch windows

## Configuration Files

### AI Agent Configs
- `~/.config/claude-code/` - Claude Code settings
- `~/.config/cursor/` - Cursor CLI settings
- `~/.config/tmux/tmux.conf` - Tmux configuration

### Environment Variables
```bash
# Add to ~/.zshrc or .env
export ANTHROPIC_API_KEY="your-claude-api-key"
export CURSOR_API_KEY="your-cursor-api-key"
export OPENCODE_API_KEY="your-opencode-api-key"
```

## Platform-Specific Notes

### macOS
- Uses Homebrew paths for tools
- Includes Secretive SSH integration
- Android SDK support for mobile development

### Linux (Ubuntu)
- Uses apt paths for tools
- Includes systemd service configurations
- Docker and Podman support

## Aliases and Functions

### AI Agent Aliases
```bash
ac          # Claude Code
ar          # Cursor via ACP
ao          # OpenCode via ACP
ai-agent    # Universal agent launcher
```

### Development Aliases
```bash
dev-ai      # Start AI development session
dev-tmux    # Start tmux development session
ai-status   # Check all AI agent statuses
```

### Utility Functions
```bash
check_agents()     # Status of all AI agents
setup_ai_env()     # Initialize AI environment
backup_sessions()  # Backup tmux sessions
```

## Troubleshooting

### Common Issues
1. **Agent not found**: Run `npm install -g` for the missing agent
2. **Authentication expired**: Re-run `agent login`
3. **Tmux session lost**: Check `tmux ls` and reattach
4. **Remote connection**: Verify Tailscale VPN status

### Debug Mode
```bash
# Enable debug logging
export AI_DEBUG=1
ai-agent claude --debug
```

## Repository Structure

```
.
├── .zshrc                    # Main shell configuration
├── .config/
│   ├── tmux/
│   │   └── tmux.conf        # Tmux configuration
│   ├── claude-code/         # Claude Code settings
│   └── cursor/              # Cursor settings
├── scripts/
│   ├── setup.sh             # Main setup script
│   ├── install_agents.sh    # AI agent installation
│   └── backup.sh            # Configuration backup
└── README.md                # This file
```

## Contributing

1. Fork the repository
2. Create feature branch
3. Test on both macOS and Linux
4. Submit pull request

## License

MIT License - see LICENSE file for details