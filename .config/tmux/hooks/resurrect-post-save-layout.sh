#!/usr/bin/env bash
# tmux-resurrect @resurrect-hook-post-save-layout. $1 = the snapshot just written,
# before save.sh repoints `last` at it (save.sh deletes it instead if it equals `last`).
set -u
snapshot=$1
last=$(dirname "$snapshot")/last

# A server that never restored holds a fresh, partial layout. Saving it would make
# `last` point at that and lose the real one, so keep `last` until a restore runs.
if [ "$(tmux show -gqv @resurrect-restored)" != 1 ] && [ -e "$last" ]; then
	cp "$(readlink -f "$last")" "$snapshot"
	tmux display-message -d 5000 "resurrect: autosave paused, this server never restored (prefix + C-r, or: tmux set -g @resurrect-restored 1)"
	exit 0
fi

# resurrect saves a pane's argv, which keeps the original `claude --resume X` after a
# /clear. Claude's registry (~/.claude/sessions/<pid>.json) tracks the live id instead.
current_claude_command() {
	local pane_pid=$1 pid id
	for pid in $(pgrep -x -P "$pane_pid" claude); do
		id=$(jq -r '.sessionId // empty' "$HOME/.claude/sessions/$pid.json" 2>/dev/null)
		# A session with no messages yet has no transcript, and --resume would fail on it.
		if [ -n "$id" ] && compgen -G "$HOME/.claude/projects/*/$id.jsonl" >/dev/null; then
			echo ":claude --resume $id"
		else
			echo ":claude"
		fi
		return
	done
}

commands=$(mktemp)
trap 'rm -f "$commands"' EXIT
awk -F'\t' '$1 == "pane" && $11 ~ /^:claude( |$)/ { print $2 "\t" $3 "\t" $6 }' "$snapshot" |
	while IFS=$'\t' read -r session window pane; do
		pane_pid=$(tmux display -p -t "=$session:$window.$pane" '#{pane_pid}' 2>/dev/null) || continue
		command=$(current_claude_command "$pane_pid")
		[ -n "$command" ] && printf '%s\t%s\t%s\t%s\n' "$session" "$window" "$pane" "$command"
	done >"$commands"

awk -F'\t' -v OFS='\t' '
	FILENAME == ARGV[1] { command[$1 FS $2 FS $3] = $4; next }
	$1 == "pane" && (($2 FS $3 FS $6) in command) { $11 = command[$2 FS $3 FS $6] }
	{ print }
' "$commands" "$snapshot" >"$snapshot.tmp" && mv "$snapshot.tmp" "$snapshot"
