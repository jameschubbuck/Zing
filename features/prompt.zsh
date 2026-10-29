# Directory above a `»`, with a blank line between commands
# The `»` is red after a command fails, and a `«` in vi command mode
# Disable to bring your own; the other features read $PROMPT's line count
zing-enabled prompt || return

() {
  zing-color base0D
  local directory="%F{$REPLY}%~%f"
  zing-color base0E
  local ok=$REPLY
  zing-color base08
  local color="%(?.%F{$ok}.%F{$REPLY})"
  typeset -g _zing_char_insert=$color'»%f ' _zing_char_command=$color'«%f '
  PROMPT=$'\n'$directory$'\n'$_zing_char_insert
  RPROMPT=
}

# Swaps the character alone, so a $PROMPT set since is left be
_zing_prompt_char() {
  local next=${PROMPT/"$_zing_char_command"/$_zing_char_insert}
  [[ $1 == command ]] && next=${next/"$_zing_char_insert"/$_zing_char_command}
  [[ $next == "$PROMPT" ]] && return
  PROMPT=$next
  zle && zle .reset-prompt
}

_zing_prompt_mode() {
  if [[ $KEYMAP == vicmd ]]; then
    _zing_prompt_char command
  else
    _zing_prompt_char insert
  fi
}
add-zle-hook-widget zle-keymap-select _zing_prompt_mode

# Back to `»` once submitted, so scrollback reads the same in either mode
# Again before the next prompt, after `./transient-prompt.zsh` restores it
_zing_prompt_insert() { _zing_prompt_char insert }
add-zle-hook-widget zle-line-finish _zing_prompt_insert
add-zsh-hook precmd _zing_prompt_insert
