# Shrink submitted prompts to their last line, so scrollback reads as commands
# Keeps a leading blank line, and works with any multi-line $PROMPT
# Also clears the suggestion (POSTDISPLAY) from scrollback

_zing_transient_prompt() {
  POSTDISPLAY=
  if [[ $PROMPT == *$'\n'* ]]; then
    typeset -g _zing_full_prompt=$PROMPT
    local head=
    [[ $PROMPT == $'\n'* ]] && head=$'\n'
    PROMPT=$head${PROMPT##*$'\n'}
  fi
  zle .reset-prompt
}
_zing_restore_prompt() {
  (( $+_zing_full_prompt )) || return
  PROMPT=$_zing_full_prompt
  unset _zing_full_prompt
}

add-zle-hook-widget zle-line-finish _zing_transient_prompt
add-zsh-hook precmd _zing_restore_prompt
