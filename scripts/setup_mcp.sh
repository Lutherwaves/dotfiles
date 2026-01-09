#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles" # Adjust to your dotfiles location
CLAUDE_CONFIG="$HOME/.claude.json"
DOTFILES_CLAUDE_CONFIG="$DOTFILES_DIR/claude/.claude.json"

# Backup existing config
if [ -f "$CLAUDE_CONFIG" ]; then
  echo "Backing up existing Claude config..."
  cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create symlink
echo "Creating symlink..."
ln -sf "$DOTFILES_CLAUDE_CONFIG" "$CLAUDE_CONFIG"

# Verify
if [ -L "$CLAUDE_CONFIG" ]; then
  echo "✅ Claude MCP config symlinked successfully"
  echo "📝 Don't forget to export GITHUB_PERSONAL_ACCESS_TOKEN in your shell rc file"
else
  echo "❌ Symlink creation failed"
  exit 1
fi
