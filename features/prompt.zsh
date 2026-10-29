# Directory above a `>`, with a blank line between commands
# The `>` is red after a command fails
# Disable to bring your own; the other features read $PROMPT's line count
zing-enabled prompt || return

() {
  zing-color base0D
  local directory="%F{$REPLY}%~%f"
  zing-color base0E
  local ok=$REPLY
  zing-color base08
  local char="%(?.%F{$ok}.%F{$REPLY})>%f "
  PROMPT=$'\n'$directory$'\n'$char
  RPROMPT=
}
