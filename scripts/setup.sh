#!/bin/bash

# Dotfiles Setup Script
# Works on macOS (Intel + Apple Silicon) and Linux
# Safe to re-run — idempotent, uses symlinks
# Uses charmbracelet/gum for pretty output when available

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

# -------------------------------------------------------------------
# Output helpers (gum with fallback)
# -------------------------------------------------------------------
HAS_GUM=false
command -v gum &>/dev/null && HAS_GUM=true

header() {
    if $HAS_GUM; then
        gum style \
            --foreground 212 --border-foreground 212 --border double \
            --align center --width 50 --padding "1 2" --margin "1 0" \
            "$@"
    else
        echo ""
        echo "========================================="
        echo "  $*"
        echo "========================================="
        echo ""
    fi
}

section() {
    if $HAS_GUM; then
        echo ""
        gum style --bold --foreground 212 "  $1"
    else
        echo ""
        echo "--- $1 ---"
    fi
}

ok() {
    if $HAS_GUM; then
        gum log --level info "$1"
    else
        echo -e "\033[0;32m[ok]\033[0m $1"
    fi
}

warn() {
    if $HAS_GUM; then
        gum log --level warn "$1"
    else
        echo -e "\033[1;33m[!!]\033[0m $1"
    fi
}

fail() {
    if $HAS_GUM; then
        gum log --level error "$1"
    else
        echo -e "\033[0;31m[FAIL]\033[0m $1"
    fi
}

spin() {
    local title="$1"
    shift
    if $HAS_GUM; then
        gum spin --spinner dot --title "$title" -- "$@"
    else
        echo -n "  $title... "
        "$@" &>/dev/null
        echo "done"
    fi
}

confirm() {
    if $HAS_GUM; then
        gum confirm --default=yes "$1"
    else
        echo -n "$1 [Y/n] "
        read -r answer
        [[ -z "$answer" || "$answer" =~ ^[Yy] ]]
    fi
}

command_exists() { command -v "$1" >/dev/null 2>&1; }

# -------------------------------------------------------------------
# Detect Homebrew prefix
# -------------------------------------------------------------------
detect_brew() {
    if [ -d /opt/homebrew ]; then
        BREW_PREFIX="/opt/homebrew"
    elif [ -d /usr/local/Homebrew ]; then
        BREW_PREFIX="/usr/local"
    else
        BREW_PREFIX=""
    fi

    if [ -n "$BREW_PREFIX" ]; then
        eval "$($BREW_PREFIX/bin/brew shellenv)"
    fi
}

detect_brew

# -------------------------------------------------------------------
# Symlink helper
# -------------------------------------------------------------------
symlink() {
    local src="$1" dst="$2" name
    name="$(basename "$dst")"

    if [ ! -e "$src" ]; then
        warn "Source not found: $src"
        return 1
    fi

    # Already correct
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        ok "$name (already linked)"
        return 0
    fi

    # Backup existing file (not symlink)
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "${dst}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backed up existing $name"
    fi

    # Remove stale symlink
    [ -L "$dst" ] && rm "$dst"

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "$name -> $(basename "$(dirname "$src")")/$(basename "$src")"
}

# -------------------------------------------------------------------
# 1. Install system dependencies
# -------------------------------------------------------------------
install_deps() {
    section "System Dependencies"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command_exists brew; then
            if confirm "Homebrew not found. Install it?"; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                detect_brew
            else
                warn "Skipping Homebrew — some things won't install"
                return
            fi
        fi

        local packages=(gum tmux neovim node git fd lazygit ripgrep
                        pyenv pyenv-virtualenv nvm
                        zsh-autosuggestions zsh-syntax-highlighting powerlevel10k)

        for pkg in "${packages[@]}"; do
            if brew list "$pkg" &>/dev/null; then
                ok "$pkg"
            else
                spin "Installing $pkg" brew install "$pkg" \
                    && ok "$pkg" \
                    || fail "Failed: $pkg"
            fi
        done

        # Re-check gum availability after installing it
        command -v gum &>/dev/null && HAS_GUM=true

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        spin "Updating apt" sudo apt update
        spin "Installing packages" sudo apt install -y \
            tmux neovim nodejs npm git curl fd-find ripgrep
        ok "System packages"
    fi
}

# -------------------------------------------------------------------
# 2. Symlink configs
# -------------------------------------------------------------------
link_configs() {
    section "Linking Configs"

    # Shell
    symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

    # Kitty
    symlink "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"

    # Tmux
    symlink "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"

    # Neovim (repo has .config/nvim/nvim — link the inner dir)
    symlink "$DOTFILES_DIR/.config/nvim/nvim" "$HOME/.config/nvim"

}

# -------------------------------------------------------------------
# 3. Plugins & tools
# -------------------------------------------------------------------
setup_plugins() {
    section "Plugins & Tools"

    # TPM (tmux plugin manager)
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        ok "TPM"
    else
        spin "Installing TPM" git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" \
            && ok "TPM" || fail "TPM failed"
    fi

    # zsh-z
    if [ -d "$HOME/.zsh-z" ]; then
        ok "zsh-z"
    else
        spin "Installing zsh-z" git clone https://github.com/agkozak/zsh-z "$HOME/.zsh-z" \
            && ok "zsh-z" || fail "zsh-z failed"
    fi

    # NVM directory
    mkdir -p "$HOME/.nvm"
    ok "nvm directory"
}

# -------------------------------------------------------------------
# 4. Containers (Colima on macOS, Docker on Linux)
# -------------------------------------------------------------------
setup_containers() {
    section "Containers"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: Colima + Docker CLI
        local colima_pkgs=(colima docker docker-compose docker-credential-helper)
        for pkg in "${colima_pkgs[@]}"; do
            if brew list "$pkg" &>/dev/null; then
                ok "$pkg"
            else
                spin "Installing $pkg" brew install "$pkg" \
                    && ok "$pkg" || fail "Failed: $pkg"
            fi
        done

        # Start Colima if not running
        if colima status &>/dev/null; then
            ok "Colima (running)"
        else
            if confirm "Start Colima now? (Apple Virtualization + Rosetta)"; then
                spin "Starting Colima" colima start --vm-type vz --vz-rosetta --cpu 4 --memory 8 \
                    && ok "Colima started" || fail "Colima failed to start"
            fi
        fi

    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists docker; then
            ok "Docker"
        else
            spin "Installing Docker" bash -c 'curl -fsSL https://get.docker.com | sh' \
                && ok "Docker" || fail "Docker install failed"
        fi
    fi
}

# -------------------------------------------------------------------
# 5. Local overrides
# -------------------------------------------------------------------
setup_local() {
    section "Local Config"

    if [ ! -f "$HOME/.zshrc.local" ]; then
        cp "$DOTFILES_DIR/.zshrc.local.example" "$HOME/.zshrc.local" 2>/dev/null || \
        cat > "$HOME/.zshrc.local" << 'EOF'
# Machine-specific config — not tracked by git
# Add API keys, local paths, etc. here

# export ANTHROPIC_API_KEY=""
# export PERPLEXITY_API_KEY=""
# export OPENROUTER_API_KEY=""
EOF
        ok "Created ~/.zshrc.local"
    else
        ok "~/.zshrc.local (exists)"
    fi

    # Save DOTFILES_DIR
    echo "export DOTFILES_DIR=\"$DOTFILES_DIR\"" > "$HOME/.dotfiles-env"
    ok "DOTFILES_DIR=$DOTFILES_DIR"
}

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
show_summary() {
    if $HAS_GUM; then
        echo ""
        gum style \
            --foreground 10 --border-foreground 10 --border rounded \
            --padding "1 2" --margin "1 0" \
            "Setup complete!" \
            "" \
            "Next steps:" \
            "  1. source ~/.zshrc" \
            "  2. Edit ~/.zshrc.local with your API keys" \
            "  3. Open nvim — plugins auto-install on first launch" \
            "  4. In tmux: prefix + I to install TPM plugins"
    else
        echo ""
        echo "========================================="
        echo "  Setup complete!"
        echo ""
        echo "  Next steps:"
        echo "    1. source ~/.zshrc"
        echo "    2. Edit ~/.zshrc.local with your API keys"
        echo "    3. Open nvim — plugins auto-install on first launch"
        echo "    4. In tmux: prefix + I to install TPM plugins"
        echo "========================================="
    fi
}

# -------------------------------------------------------------------
# Main
# -------------------------------------------------------------------
main() {
    header "Dotfiles Setup"

    install_deps
    link_configs
    setup_plugins
    setup_containers
    setup_local
    show_summary
}

main "$@"
