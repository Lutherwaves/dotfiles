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

# --- Claude Code Router (CCR) ---
# 1) Always set ANTHROPIC_* env vars in this shell
if command -v ccr >/dev/null 2>&1; then
  eval "$(ccr activate)"
fi

# 2) Auto-start CCR when you run `claude`
claude() {
  if ! command -v ccr >/dev/null 2>&1; then
    echo "ccr not found in PATH"
    return 127
  fi

  # Start CCR only if it's not running
  if ! ccr status >/dev/null 2>&1; then
    ccr start >/dev/null 2>&1
  fi

  # Ensure current shell has the correct env (in case you opened a new terminal)
  eval "$(ccr activate)"

  command claude "$@"
}

