#!/bin/bash

# Configuration Backup Script
# Purpose: Backup AI development configurations

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Create backup
backup_configs() {
    local backup_dir="$HOME/.ai-config-backup/$(date +%Y%m%d_%H%M%S)"
    
    print_status "Creating configuration backup..."
    mkdir -p "$backup_dir"
    
    # Backup shell configuration
    [ -f ~/.zshrc ] && cp ~/.zshrc "$backup_dir/"
    
    # Backup AI configs
    [ -d ~/.config/claude-code ] && cp -r ~/.config/claude-code "$backup_dir/"
    [ -d ~/.config/cursor ] && cp -r ~/.config/cursor "$backup_dir/"
    [ -d ~/.config/tmux ] && cp -r ~/.config/tmux "$backup_dir/"
    
    # Backup tmux sessions
    if command -v tmux >/dev/null 2>&1; then
        mkdir -p "$backup_dir/tmux-sessions"
        tmux list-sessions 2>/dev/null | while read -r session; do
            session_name=$(echo "$session" | cut -d: -f1)
            tmux capture-pane -t "$session_name" -S - > "$backup_dir/tmux-sessions/${session_name}.log" 2>/dev/null || true
        done
    fi
    
    # Backup environment files
    [ -f ~/.ai-env ] && cp ~/.ai-env "$backup_dir/"
    
    print_success "Configuration backed up to: $backup_dir"
}

# Restore from backup
restore_configs() {
    local backup_dir="$1"
    
    if [ -z "$backup_dir" ]; then
        echo "Usage: $0 restore <backup_directory>"
        return 1
    fi
    
    print_status "Restoring configuration from: $backup_dir"
    
    # Restore shell configuration
    [ -f "$backup_dir/.zshrc" ] && cp "$backup_dir/.zshrc" ~/.zshrc
    
    # Restore AI configs
    [ -d "$backup_dir/claude-code" ] && cp -r "$backup_dir/claude-code" ~/.config/
    [ -d "$backup_dir/cursor" ] && cp -r "$backup_dir/cursor" ~/.config/
    [ -d "$backup_dir/tmux" ] && cp -r "$backup_dir/tmux" ~/.config/
    
    # Restore environment
    [ -f "$backup_dir/.ai-env" ] && cp "$backup_dir/.ai-env" ~/.ai-env
    
    print_success "Configuration restored"
}

# List available backups
list_backups() {
    local backup_dir="$HOME/.ai-config-backup"
    
    if [ ! -d "$backup_dir" ]; then
        print_status "No backups found"
        return
    fi
    
    print_status "Available backups:"
    ls -la "$backup_dir" | grep '^d' | grep -v '^\.$\|^\.\.$' | awk '{print $NF}'
}

# Show help
show_help() {
    echo "Configuration Backup Script"
    echo ""
    echo "Usage: $0 [backup|restore|list|help]"
    echo ""
    echo "Commands:"
    echo "  backup   - Create new backup"
    echo "  restore  - Restore from backup (requires backup directory)"
    echo "  list     - List available backups"
    echo "  help     - Show this help"
}

# Main function
main() {
    case "${1:-backup}" in
        "backup")
            backup_configs
            ;;
        "restore")
            restore_configs "$2"
            ;;
        "list")
            list_backups
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

main "$@"