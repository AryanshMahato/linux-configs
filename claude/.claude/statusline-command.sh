#!/bin/sh
input=$(cat)

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -z "$used_pct" ]; then
  exit 0
fi

consumed=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

if [ -z "$consumed" ]; then
  exit 0
fi

used_int=$(printf '%.0f' "$used_pct")
consumed_k=$(( (consumed + 500) / 1000 ))

printf '\033[38;5;109mContext: %s%% (%sk)\033[0m' "$used_int" "$consumed_k"
