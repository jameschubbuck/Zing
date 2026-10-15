# Directory above a `>`, with a blank line between commands
# Disable to bring your own; the other features read $PROMPT's line count
zing-enabled prompt || return

() {
  zing-color base0D
  local directory="%F{$REPLY}%~%f"
  zing-color base0E
  local char="%F{$REPLY}>%f "
  PROMPT=$'\n'$directory$'\n'$char
  RPROMPT=
}
