# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Android SDK for IONIC 4
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk

# avdmanager, sdkmanager
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin

# adb, logcat
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# build tools like zipalign
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/29.0.3

# emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator

# pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -s "/Users/martinyankov/.jabba/jabba.sh" ] && source "/Users/martinyankov/.jabba/jabba.sh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.

# if type brew &>/dev/null; then
#     FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

#     autoload -Uz compinit
#     compinit
# fi

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
plugins=(git zsh-autosuggestions kubectl golang docker terraform z)

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-z/zsh-z.plugin.zsh
source /usr/local/Cellar/powerlevel10k/1.20.0/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load Angular CLI autocompletion.
# source <(ng completion script)

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
# Go PATH
export PATH="$PATH:$(go env GOPATH)/bin"

alias air="$(go env GOPATH)/bin/air"
alias vim="nvim"
export EDITOR="nvim"
export PERPLEXITY_API_KEY=1234567890


# Secretive Config
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

. "$HOME/.local/bin/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"

export GOPRIVATE=github.com/blox-eng/*
export PATH="/usr/local/opt/postgresql@17/bin:$PATH"
export PATH="/usr/local/opt/postgresql@17/bin:$PATH"

# -------------------------------------------------------------------
# Claude Code + Claude Code Router (CCR) dual-mode launcher for zsh
#
# Goal:
#   - `claude`  = normal Claude Code (no router)
#   - `clauder` = Claude Code routed through CCR (auto-starts CCR)
#
# IMPORTANT: remove your old auto-activation + old `claude()` wrapper.
# In particular, do NOT keep `eval "$(ccr activate)"` at shell startup,
# because it forces router mode globally. [page:0]
# -------------------------------------------------------------------

# Resolve the real Claude Code binary path once, before we define functions.
# This avoids recursion when we create a `claude()` function.
typeset -g CLAUDE_BIN="${commands[claude]}"

# Helper: does ccr exist?
_ccr_exists() { command -v ccr >/dev/null 2>&1 }

# Helper: start CCR if not running
_ccr_start_if_needed() {
  _ccr_exists || { echo "ccr not found in PATH"; return 127; }
  ccr status >/dev/null 2>&1 || ccr start >/dev/null 2>&1
}

# -------------------------------------------------
# 1) Normal Claude Code (no router)
# -------------------------------------------------
claude() {
  # Ensure CCR env vars are not affecting this run.
  unset ANTHROPIC_BASE_URL
  unset ANTHROPIC_AUTH_TOKEN
  unset ANTHROPIC_API_KEY
  unset DISABLE_TELEMETRY
  unset DISABLE_COST_WARNINGS
  unset API_TIMEOUT_MS

  # If you previously exported proxy vars globally and saw connection issues,
  # you can uncomment these. (Leave them commented if you need proxy normally.)
  # unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy
  # export NO_PROXY="127.0.0.1,localhost"
  # export no_proxy="127.0.0.1,localhost"

  command "$CLAUDE_BIN" "$@"
}

# -------------------------------------------------
# 2) Claude Code via CCR (router)
# -------------------------------------------------
clauder() {
  _ccr_start_if_needed || return $?

  # CCR's activate command outputs shell exports for:
  # - ANTHROPIC_BASE_URL (default http://127.0.0.1:3456)
  # - NO_PROXY=127.0.0.1 (to prevent proxy interference)
  # - other router-related vars [page:0]
  eval "$(ccr activate)"

  # Extra safety: make sure localhost bypass is set (some envs need both forms).
  export NO_PROXY="127.0.0.1,localhost"
  export no_proxy="127.0.0.1,localhost"

  command "$CLAUDE_BIN" "$@"
}

# Optional convenience commands
alias ccrs='ccr status || ccr start'
alias ccrstop='ccr stop'
alias ccrrestart='ccr restart'
