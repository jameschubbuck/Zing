# Clear the screen and scrollback, keeping the prompt on the bottom row

_zing_clear() {
  [[ -t 1 ]] || return
  _zing_prompt_lines
  printf '\e[H\e[2J\e[3J\e[%d;1H' $((LINES - REPLY + 1))
}

clear() { _zing_clear }

# reset(1) leaves the cursor at the top
reset() {
  command reset "$@"
  local ret=$?
  _zing_clear
  return ret
}

# Forget the drawn prompt first, so zle redraws it at the new cursor
_zing_clear_widget() {
  zle -I
  _zing_clear
}
zle -N _zing_clear_widget
bindkey -M viins '^L' _zing_clear_widget
bindkey -M vicmd '^L' _zing_clear_widget
