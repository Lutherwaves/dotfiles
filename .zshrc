# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------------------------------------------
# Dotfiles bootstrap
# -------------------------------------------------------------------
[ -f "$HOME/.dotfiles-env" ] && source "$HOME/.dotfiles-env"
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Detect Homebrew prefix (Apple Silicon vs Intel vs Linux)
if [ -d /opt/homebrew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# -------------------------------------------------------------------
# Language version managers (guarded)
# -------------------------------------------------------------------

# pyenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" 2>/dev/null
fi

# nvm
export NVM_DIR="$HOME/.nvm"
if [ -n "$HOMEBREW_PREFIX" ] && [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
    \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi
mkdir -p "$NVM_DIR"

# Jabba (Java Version Manager)
[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

# Go
if command -v go &>/dev/null; then
    export PATH="$PATH:$(go env GOPATH)/bin"
    alias air="$(go env GOPATH)/bin/air"
fi
# export GOPRIVATE= # set in ~/.zshrc.local for private module hosts

# -------------------------------------------------------------------
# Zsh plugins (use brew prefix, no hardcoded paths)
# -------------------------------------------------------------------

if [ -n "$HOMEBREW_PREFIX" ]; then
    [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
        source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    [ -f "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ] && \
        source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

# zsh-z
[ -f "$HOME/.zsh-z/zsh-z.plugin.zsh" ] && source "$HOME/.zsh-z/zsh-z.plugin.zsh"

plugins=(git zsh-autosuggestions kubectl golang docker terraform z)

# p10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -------------------------------------------------------------------
# Editor & tools
# -------------------------------------------------------------------
alias vim="nvim"
export EDITOR="nvim"

# -------------------------------------------------------------------
# PATH additions (guarded)
# -------------------------------------------------------------------

# Android SDK (macOS only)
if [[ "$OSTYPE" == "darwin"* ]] && [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
    export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"
    export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
    export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
fi

# Bun
if [ -d "$HOME/.bun" ]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# RVM
[ -d "$HOME/.rvm/bin" ] && export PATH="$PATH:$HOME/.rvm/bin"

# Rancher Desktop
[ -d "$HOME/.rd/bin" ] && export PATH="$HOME/.rd/bin:$PATH"

# PostgreSQL (find whatever version is installed)
if [ -n "$HOMEBREW_PREFIX" ] && ls "$HOMEBREW_PREFIX/opt/postgresql@"*/bin &>/dev/null; then
    for pg in "$HOMEBREW_PREFIX/opt/postgresql@"*/bin; do
        [ -d "$pg" ] && export PATH="$pg:$PATH" && break
    done
fi

# Misc
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Google Cloud SDK
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"
# Fallback: Downloads location
[ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"

# Secretive (macOS SSH key agent)
if [[ "$OSTYPE" == "darwin"* ]]; then
    local _secretive_sock="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
    [ -S "$_secretive_sock" ] && export SSH_AUTH_SOCK="$_secretive_sock"
fi

# -------------------------------------------------------------------
# Tmux helpers
# -------------------------------------------------------------------

dev-tmux() {
  local session_name="dev-tmux"

  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach -t "$session_name"
    return
  fi

  tmux new-session -d -s "$session_name" -n editor "nvim"
  tmux split-window -v -t "$session_name:0"
  tmux split-window -h -t "$session_name:0.1"
  tmux select-pane -t "$session_name:0.0"
  tmux attach -t "$session_name"
}

alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux ls'
alias tk='tmux kill-session -t'
alias tmux-dev='dev-tmux'

# Tmux navigation helpers (Kitty-friendly)
if [ -f "$DOTFILES_DIR/scripts/tmux-nav.sh" ]; then
    alias tn="$DOTFILES_DIR/scripts/tmux-nav.sh next"
    alias tp="$DOTFILES_DIR/scripts/tmux-nav.sh prev"
    alias t1="$DOTFILES_DIR/scripts/tmux-nav.sh 1"
    alias t2="$DOTFILES_DIR/scripts/tmux-nav.sh 2"
    alias t3="$DOTFILES_DIR/scripts/tmux-nav.sh 3"
    alias tl="$DOTFILES_DIR/scripts/tmux-nav.sh list"
fi

# -------------------------------------------------------------------
# Machine-local overrides (API keys, personal paths, etc.)
# -------------------------------------------------------------------
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
