# Start a fresh terminal's first prompt on the bottom row
# Once per terminal, exported so nested shells skip it
zing-enabled bottom-prompt || return

if [[ -t 1 && $_ZING_ANCHORED_TTY != $TTY ]]; then
  export _ZING_ANCHORED_TTY=$TTY
  _zing_prompt_lines
  printf '\n%.0s' {1..$LINES}
  printf '\e[%dA' $((REPLY - 1))
fi
