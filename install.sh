#!/bin/bash

# Dotfiles installer
#
# One-liner for a fresh machine:
#   curl -fsSL https://raw.githubusercontent.com/Lutherwaves/dotfiles/main/install.sh | bash
#
# Or clone first:
#   git clone https://github.com/Lutherwaves/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh

set -e

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# If run via curl pipe, we need to clone first
if [ ! -f "$DOTFILES_DIR/scripts/setup.sh" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/Lutherwaves/dotfiles.git "$DOTFILES_DIR"
fi

export DOTFILES_DIR
exec "$DOTFILES_DIR/scripts/setup.sh"
