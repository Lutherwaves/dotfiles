#!/bin/bash

# One-line Dotfiles Setup Script
# Purpose: Clone and setup dotfiles on a new machine

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

# Main setup
main() {
    print_status "Setting up AI development environment..."
    
    # Clone dotfiles if not present
    if [ ! -d ~/.dotfiles ]; then
        print_status "Cloning dotfiles repository..."
        git clone https://github.com/Lutherwaves/dotfiles.git ~/.dotfiles
    else
        print_status "Dotfiles already exist, updating..."
        cd ~/.dotfiles
        git pull
    fi
    
    # Run setup script
    print_status "Running setup script..."
    cd ~/.dotfiles
    ./scripts/setup.sh
    
    print_success "Setup complete! 🎉"
    echo ""
    print_status "Next steps:"
    echo "1. Reload your shell: source ~/.zshrc"
    echo "2. Configure API keys in ~/.ai-env"
    echo "3. Start developing: dev-ai claude"
}

main "$@"