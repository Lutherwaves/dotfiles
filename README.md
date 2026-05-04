# Dotfiles

Personal dotfiles for an AI-powered dev environment. macOS (Intel + Apple Silicon) and Linux.

## Install

Fresh machine, one command:

```bash
curl -fsSL https://raw.githubusercontent.com/Lutherwaves/dotfiles/main/install.sh | bash
```

Or clone first:

```bash
git clone https://github.com/Lutherwaves/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The setup script is idempotent — safe to re-run anytime.

## What it does

The setup script will:

1. Install system dependencies via Homebrew (or apt on Linux)
2. Symlink all configs to your home directory
3. Install zsh plugins, TPM, zsh-z, nvm
4. Optionally install Claude Code
5. Create `~/.zshrc.local` for your machine-specific config (API keys, etc.)

Uses [charmbracelet/gum](https://github.com/charmbracelet/gum) for pretty output when available (installed automatically).

## What's included

| Config | Location in repo | Symlinked to |
|--------|-----------------|--------------|
| Zsh shell config | `.zshrc` | `~/.zshrc` |
| Git config | `.gitconfig` | `~/.gitconfig` |
| Kitty terminal | `.config/kitty/` | `~/.config/kitty` |
| Tmux | `.config/tmux/` | `~/.config/tmux` |
| Neovim (LazyVim) | `.config/nvim/nvim/` | `~/.config/nvim` |
| Claude rules | `.claude/*.md` | `~/.claude/*.md` |
| Cursor rules | `.cursor/*.mdc` | `~/.cursor/*.mdc` |

### System packages installed

tmux, neovim, node, git, fd, lazygit, ripgrep, pyenv, pyenv-virtualenv, nvm, gum, zsh-autosuggestions, zsh-syntax-highlighting, powerlevel10k

## After install

```bash
source ~/.zshrc
```

Edit `~/.zshrc.local` with your API keys and machine-specific paths:

```bash
export ANTHROPIC_API_KEY="..."
export PERPLEXITY_API_KEY="..."
```

Open `nvim` — LazyVim plugins and LSPs install automatically on first launch.

In tmux, press `Ctrl+Space` then `I` to install TPM plugins.

## Local LLM (Ollama)

The setup optionally installs [Ollama](https://ollama.com) for local inference. Since Ollama v0.14+, it natively supports the Anthropic Messages API — no proxy needed.

```bash
# Use Claude Code with a local model
claudeo                        # uses qwen2.5:32b by default
claudeo deepseek-r1:32b       # specify a different model
co                             # alias for claudeo
```

Set default model in `~/.zshrc.local`:

```bash
export OLLAMA_MODEL="deepseek-r1:32b"
```

Three ways to run Claude Code:
- `claude` — direct Anthropic API
- `clauder` — via Claude Code Router (OpenRouter, Perplexity, etc.)
- `claudeo` — via local Ollama

## Shell aliases

| Alias | What it does |
|-------|-------------|
| `dev` / `dev-ai` | Start a tmux session with an AI agent |
| `tmux-dev` | Start a tmux dev session (no AI) |
| `claude` | Run Claude Code (direct API) |
| `clauder` | Run Claude Code through CCR router |
| `claudeo` / `co` | Run Claude Code with local Ollama |
| `ac` | Shortcut for `ai-agent claude` |
| `ta` / `tn` / `tl` / `tk` | tmux attach / new / list / kill |
| `vim` | Opens neovim |

## Updating

```bash
cd ~/.dotfiles && git pull
```

Since configs are symlinked, pulling is enough — no need to re-run setup unless new dependencies were added.

## Repo structure

```
.
├── install.sh              # Entry point (curl-friendly, clones + runs setup)
├── scripts/
│   ├── setup.sh            # Main setup (deps, symlinks, plugins)
│   └── backup.sh           # Backup existing configs
├── .zshrc                  # Shell config (portable, uses $HOMEBREW_PREFIX)
├── .zshrc.local.example    # Template for machine-specific overrides
├── .gitconfig               # Git config
├── .config/
│   ├── kitty/              # Kitty terminal config
│   ├── tmux/               # Tmux config + layouts
│   └── nvim/nvim/          # Neovim LazyVim config
├── .claude/                # Claude AI rules and config
├── .cursor/                # Cursor IDE rules and MCP config
└── .claude-code-router/    # Claude Code Router config
```

## License

MIT — see [LICENSE.md](LICENSE.md).
