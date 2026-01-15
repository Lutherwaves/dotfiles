#!/bin/bash

# AI Agent Installation Script
# Platform: Linux/macOS
# Purpose: Install and configure AI coding agents

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Install Claude Code
install_claude() {
    print_status "Installing Claude Code..."
    
    if command -v claude >/dev/null 2>&1; then
        print_success "Claude Code already installed"
        return
    fi
    
    npm install -g @anthropic-ai/claude-code
    print_success "Claude Code installed"
    
    # Prompt for login
    print_status "Run 'claude login' to authenticate"
}

# Install Cursor CLI and ACP adapter
install_cursor() {
    print_status "Installing Cursor CLI..."
    
    if command -v cursor-agent >/dev/null 2>&1; then
        print_success "Cursor CLI already installed"
    else
        curl https://cursor.com/install -fsSL | bash
        print_success "Cursor CLI installed"
    fi
    
    print_status "Installing Cursor ACP adapter..."
    
    if command -v cursor-agent-acp >/dev/null 2>&1; then
        print_success "Cursor ACP adapter already installed"
    else
        npm install -g @blowmage/cursor-agent-acp-npm
        print_success "Cursor ACP adapter installed"
    fi
    
    # Prompt for login
    print_status "Run 'cursor-agent login' to authenticate"
}

# Install OpenCode
install_opencode() {
    print_status "Installing OpenCode..."
    
    if command -v opencode >/dev/null 2>&1; then
        print_success "OpenCode already installed"
        return
    fi
    
    npm install -g opencode
    print_success "OpenCode installed"
}

# Install all agents
install_all() {
    print_status "Installing all AI agents..."
    install_claude
    install_cursor
    install_opencode
    print_success "All AI agents installed"
}

# Show help
show_help() {
    echo "AI Agent Installation Script"
    echo ""
    echo "Usage: $0 [claude|cursor|opencode|all|help]"
    echo ""
    echo "Commands:"
    echo "  claude    - Install Claude Code"
    echo "  cursor   - Install Cursor CLI and ACP adapter"
    echo "  opencode  - Install OpenCode"
    echo "  all       - Install all agents"
    echo "  help      - Show this help"
}

# Main function
main() {
    case "${1:-all}" in
        "claude")
            install_claude
            ;;
        "cursor")
            install_cursor
            ;;
        "opencode")
            install_opencode
            ;;
        "all")
            install_all
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

main "$@"