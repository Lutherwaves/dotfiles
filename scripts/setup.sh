#!/bin/bash

# AI Development Environment Setup Script
# Platform: Linux/macOS
# Purpose: One-click setup for AI coding environment

set -e

# Get DOTFILES_DIR from environment or use default
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLATFORM="macos"
        PKG_MANAGER="brew"
        print_status "Detected platform: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        PLATFORM="linux"
        PKG_MANAGER="apt"
        print_status "Detected platform: Linux"
    else
        print_error "Unsupported platform: $OSTYPE"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install system dependencies
install_system_deps() {
    print_status "Installing system dependencies..."
    
    case "$PLATFORM" in
        "macos")
            if ! command_exists brew; then
                print_status "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install tmux node git
            ;;
        "linux")
            sudo apt update
            sudo apt install -y tmux nodejs npm git curl
            ;;
    esac
}

# Install AI agents
install_ai_agents() {
    print_status "Installing AI coding agents..."
    
    # Claude Code
    if ! command_exists claude; then
        print_status "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
    else
        print_success "Claude Code already installed"
    fi
    
    # Cursor CLI
    if ! command_exists cursor-agent; then
        print_status "Installing Cursor CLI..."
        curl https://cursor.com/install -fsSL | bash
    else
        print_success "Cursor CLI already installed"
    fi
    
    # Cursor ACP Adapter
    if ! command_exists cursor-agent-acp; then
        print_status "Installing Cursor ACP adapter..."
        npm install -g @blowmage/cursor-agent-acp-npm
    else
        print_success "Cursor ACP adapter already installed"
    fi
    
    # OpenCode
    if ! command_exists opencode; then
        print_status "Installing OpenCode..."
        npm install -g opencode
    else
        print_success "OpenCode already installed"
    fi
}

# Setup tmux
setup_tmux() {
    print_status "Setting up tmux..."
    
    # Create tmux config directory
    mkdir -p ~/.tmux/plugins
    
    # Install tmux plugin manager
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        print_status "Installing tmux plugin manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    
    # Copy tmux configuration
    if [ -f "$DOTFILES_DIR/.config/tmux/tmux.conf" ]; then
        mkdir -p ~/.config/tmux
        cp "$DOTFILES_DIR/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
        if [ -f "$DOTFILES_DIR/.config/tmux/ai-layout.conf" ]; then
            cp "$DOTFILES_DIR/.config/tmux/ai-layout.conf" ~/.config/tmux/ai-layout.conf
        fi
        if [ -f "$DOTFILES_DIR/.config/tmux/dev-layout.conf" ]; then
            cp "$DOTFILES_DIR/.config/tmux/dev-layout.conf" ~/.config/tmux/dev-layout.conf
        fi
        print_success "Tmux configuration copied"
    fi
}

# Setup shell configuration
setup_shell() {
    print_status "Setting up shell configuration..."
    
    # Backup existing .zshrc
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
        print_warning "Existing .zshrc backed up"
    fi
    
    # Copy new .zshrc
    cp "$DOTFILES_DIR/.zshrc" ~/.zshrc
    print_success "Shell configuration updated"
    
    # Ensure DOTFILES_DIR is set in .zshrc environment
    if [ -f "$HOME/.dotfiles-env" ]; then
        source "$HOME/.dotfiles-env"
    else
        # Create .dotfiles-env if it doesn't exist
        echo "export DOTFILES_DIR=\"$DOTFILES_DIR\"" > "$HOME/.dotfiles-env"
        print_success "Created $HOME/.dotfiles-env"
    fi
}

# Create AI environment directories
create_directories() {
    print_status "Creating AI environment directories..."
    
    mkdir -p ~/.config/claude-code
    mkdir -p ~/.config/cursor
    mkdir -p ~/.config/tmux
    mkdir -p ~/.ai-sessions
    
    print_success "Directories created"
}

# Setup environment file
setup_env() {
    print_status "Setting up environment configuration..."
    
    local env_file="$HOME/.ai-env"
    
    cat > "$env_file" << EOF
# AI Development Environment Variables
# Configure these with your actual API keys

# Claude Code
# export ANTHROPIC_API_KEY="your-claude-api-key"

# Cursor
# export CURSOR_API_KEY="your-cursor-api-key"

# OpenCode
# export OPENCODE_API_KEY="your-opencode-api-key"

# Development Settings
export AI_SESSION_DIR="$HOME/.ai-sessions"
export AI_LOG_LEVEL="info"
export AI_DEBUG="0"

# Show status on shell startup (set to 1 to enable)
export AI_SHOW_STATUS="0"
EOF
    
    print_success "Environment file created: $env_file"
    print_warning "Edit $env_file with your API keys"
}

# Verify installation
verify_installation() {
    print_status "Verifying installation..."
    
    local errors=0
    
    # Check commands
    for cmd in tmux node npm git; do
        if command_exists "$cmd"; then
            print_success "$cmd: ✅"
        else
            print_error "$cmd: ❌"
            ((errors++))
        fi
    done
    
    # Check AI agents
    for cmd in claude cursor-agent cursor-agent-acp opencode; do
        if command_exists "$cmd"; then
            print_success "$cmd: ✅"
        else
            print_warning "$cmd: ❌ (may require manual installation)"
        fi
    done
    
    if [ $errors -eq 0 ]; then
        print_success "Installation verified successfully!"
    else
        print_error "Installation has $errors errors"
        return 1
    fi
}

# Main setup function
main() {
    print_status "Starting AI Development Environment setup..."
    
    detect_platform
    install_system_deps
    install_ai_agents
    setup_tmux
    setup_shell
    create_directories
    setup_env
    verify_installation
    
    print_success "Setup complete! 🎉"
    echo ""
    print_status "Next steps:"
    echo "1. Reload your shell: source ~/.zshrc"
    echo "2. Configure API keys in ~/.ai-env"
    echo "3. Authenticate with AI agents:"
    echo "   - claude login"
    echo "   - cursor-agent login"
    echo "4. Start your first AI session: dev-ai claude"
    echo ""
    print_status "For help, run: ai-agent help"
}

# Run main function
main "$@"