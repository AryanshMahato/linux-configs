#!/bin/sh
# Emits a styled tmux status pill for the git repo containing $1, or nothing at
# all when $1 is not in a work tree (so the pill disappears rather than showing
# an empty block).
#
# Pill layout:  [sep][accent block:  git /  linked worktree][gray block: branch + state]
#
# State, appended after the branch name:
#          in sync with upstream
#   ↑N      N commits ahead, waiting to be pushed
#   ↓N      N commits behind upstream
#   ↑N ↓M   diverged: N to push, M to pull
#          no upstream yet (branch has never been pushed)
#   (none)   detached HEAD - the short SHA is shown in place of a branch name
#
# Glyphs are Nerd Font (U+E0A0 branch, U+F0C1 link, U+F00C check, U+F128 question),
# matching the monochrome icons in the neighbouring pills. Colours are the
# catppuccin-mocha values the theme plugin uses:
#   orange #fab387   surface/gray #313244   base/bg #1e1e2e   fg #cdd6f4
SEP=""

dir="$1"
[ -n "$dir" ] || exit 0

# Two lines: this work tree's git dir, and the repo's shared one. They differ
# only in a linked worktree. Also the cheapest "is this a repo at all" check.
dirs=$(git -C "$dir" rev-parse --git-dir --git-common-dir 2>/dev/null) || exit 0
{ read -r gitdir; read -r common; } <<INNER
$dirs
INNER

icon=""
[ "$gitdir" != "$common" ] && icon=""

# symbolic-ref rather than rev-parse: it still answers on an unborn branch, and
# its failure is exactly the detached-HEAD case.
if branch=$(git -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null); then
  if counts=$(git -C "$dir" rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null); then
    # rev-list prints "<behind>\t<ahead>" relative to the upstream.
    set -- $counts
    behind=$1
    ahead=$2
    state=""
    [ "$ahead" -gt 0 ] 2>/dev/null && state=" ↑$ahead"
    [ "$behind" -gt 0 ] 2>/dev/null && state="$state ↓$behind"
    [ -n "$state" ] || state=" "
  else
    state=" "
  fi
else
  state=""
  branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null) || branch="detached"
fi

printf '#[fg=#fab387]#[bg=#313244]%s#[fg=#1e1e2e]#[bg=#fab387] %s #[fg=#cdd6f4]#[bg=#313244] %s%s ' \
  "$SEP" "$icon" "$branch" "$state"
