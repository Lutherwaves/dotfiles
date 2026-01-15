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

# -------------------------------------------------------------------
# AI Development Environment - Multi-Agent Support
# -------------------------------------------------------------------

# Universal AI Agent Launcher
ai-agent() {
  case "$1" in
    "claude")
      echo "🤖 Starting Claude Code..."
      claude
      ;;
    "cursor")
      echo "🔷 Starting Cursor via ACP..."
      if command -v cursor-agent-acp >/dev/null 2>&1; then
        cursor-agent-acp
      else
        echo "❌ Cursor ACP adapter not found. Install with: npm install -g @blowmage/cursor-agent-acp"
        return 1
      fi
      ;;
    "opencode")
      echo "⚡ Starting OpenCode via ACP..."
      if command -v opencode >/dev/null 2>&1; then
        opencode acp
      else
        echo "❌ OpenCode not found. Install with: npm install -g opencode"
        return 1
      fi
      ;;
    "status")
      echo "🔍 AI Agent Status:"
      echo "  Claude Code: $(command -v claude >/dev/null 2>&1 && echo "✅ Installed" || echo "❌ Not found")"
      echo "  Cursor CLI: $(command -v cursor-agent >/dev/null 2>&1 && echo "✅ Installed" || echo "❌ Not found")"
      echo "  Cursor ACP: $(command -v cursor-agent-acp >/dev/null 2>&1 && echo "✅ Installed" || echo "❌ Not found")"
      echo "  OpenCode: $(command -v opencode >/dev/null 2>&1 && echo "✅ Installed" || echo "❌ Not found")"
      ;;
    "help"|*)
      echo "🤖 AI Agent Launcher"
      echo "Usage: ai-agent [claude|cursor|opencode|status|help]"
      echo ""
      echo "  claude   - Launch Claude Code"
      echo "  cursor   - Launch Cursor via ACP"
      echo "  opencode - Launch OpenCode via ACP"
      echo "  status   - Show installation status"
      echo "  help     - Show this help"
      ;;
  esac
}

# Quick AI Agent Aliases
alias ac='ai-agent claude'      # Claude Code
alias ar='ai-agent cursor'      # Cursor via ACP
alias ao='ai-agent opencode'    # OpenCode via ACP
alias as='ai-agent status'      # Agent status

# -------------------------------------------------------------------
# Tmux Remote Development Setup
# -------------------------------------------------------------------

# Create AI development session
dev-ai() {
  local session_name="dev-ai"
  local agent="${1:-claude}"
  
  echo "🚀 Starting AI development session..."
  echo "   Session: $session_name"
  echo "   Agent: $agent"
  
  # Check if session already exists
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "📎 Attaching to existing session..."
    tmux attach -t "$session_name"
    return
  fi
  
  # Create new session with AI agent
  tmux new-session -d -s "$session_name" "ai-agent $agent"
  
  # Create additional panes for development
  tmux split-window -h -t "$session_name:0"
  tmux split-window -v -t "$session_name:0.1"
  
  # Select first pane and attach
  tmux select-pane -t "$session_name:0.0"
  tmux attach -t "$session_name"
}

# Create tmux development session (no AI)
dev-tmux() {
  local session_name="dev-tmux"
  
  echo "🚀 Starting tmux development session..."
  
  if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach -t "$session_name"
    return
  fi
  
  # Create session with editor, terminal, and logs
  tmux new-session -d -s "$session_name" -n editor "nvim"
  tmux split-window -v -t "$session_name:0" 
  tmux split-window -h -t "$session_name:0.1"
  tmux select-pane -t "$session_name:0.0"
  tmux attach -t "$session_name"
}

# Tmux session management aliases
alias ta='tmux attach -t'      # Attach to session
alias tn='tmux new -s'         # New session
alias tl='tmux ls'             # List sessions
alias tk='tmux kill-session -t' # Kill session

# Quick session creation
alias dev='dev-ai'            # AI development session
alias tmux-dev='dev-tmux'      # Regular tmux session

# -------------------------------------------------------------------
# AI Environment Utilities
# -------------------------------------------------------------------

# Check all AI agent statuses
check_agents() {
  echo "🔍 AI Development Environment Status"
  echo "=================================="
  ai-agent status
  echo ""
  echo "🌐 Network Status:"
  echo "  Tailscale: $(command -v tailscale >/dev/null 2>&1 && tailscale status >/dev/null 2>&1 && echo "✅ Connected" || echo "❌ Disconnected")"
  echo ""
  echo "📦 Tmux Sessions:"
  tmux ls 2>/dev/null || echo "  No active sessions"
}

# Setup AI environment (run once)
setup_ai_env() {
  echo "🔧 Setting up AI development environment..."
  
  # Create necessary directories
  mkdir -p ~/.config/claude-code
  mkdir -p ~/.config/cursor
  mkdir -p ~/.config/tmux
  
  # Install tmux plugins if not present
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "📦 Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
  
  echo "✅ AI environment setup complete!"
  echo "💡 Run 'dev-ai' to start your first AI development session."
}

# Backup tmux sessions
backup_sessions() {
  local backup_dir="$HOME/.tmux-sessions-backup"
  mkdir -p "$backup_dir"
  
  echo "💾 Backing up tmux sessions..."
  
  tmux list-sessions | while read -r session; do
    session_name=$(echo "$session" | cut -d: -f1)
    tmux capture-pane -t "$session_name" -S - > "$backup_dir/${session_name}_$(date +%Y%m%d_%H%M%S).log"
  done
  
  echo "✅ Sessions backed up to $backup_dir"
}

# -------------------------------------------------------------------
# Platform Detection and Configuration
# -------------------------------------------------------------------

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
  export AI_PLATFORM="macos"
  export AI_CONFIG_HOME="$HOME/Library/Application Support"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export AI_PLATFORM="linux"
  export AI_CONFIG_HOME="$HOME/.config"
fi

# Platform-specific paths
case "$AI_PLATFORM" in
  "macos")
    export AI_BIN_PATH="/usr/local/bin"
    ;;
  "linux")
    export AI_BIN_PATH="/usr/local/bin"
    ;;
esac

# -------------------------------------------------------------------
# Environment Variables (configure as needed)
# -------------------------------------------------------------------

# AI API Keys (set these in your environment or .env file)
# export ANTHROPIC_API_KEY="your-claude-api-key"
# export CURSOR_API_KEY="your-cursor-api-key"  
# export OPENCODE_API_KEY="your-opencode-api-key"

# AI Development Settings
export AI_SESSION_DIR="$HOME/.ai-sessions"
export AI_LOG_LEVEL="info"
export AI_DEBUG="${AI_DEBUG:-0}"

# Create session directory
mkdir -p "$AI_SESSION_DIR"

# -------------------------------------------------------------------
# Welcome Message
# -------------------------------------------------------------------

# Show AI environment status on shell startup (optional)
if [ "$AI_SHOW_STATUS" = "1" ]; then
  check_agents
fi
