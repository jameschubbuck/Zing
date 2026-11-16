# Block in command mode, beam in insert mode
# Each change also unhides the cursor, hidden by `../env.zsh`

_zing_cursor_shape() {
  case $KEYMAP in
    vicmd) printf '\e[?25h\e[2 q' ;;
    *) printf '\e[?25h\e[6 q' ;;
  esac
}
add-zle-hook-widget zle-keymap-select _zing_cursor_shape
add-zle-hook-widget zle-line-init _zing_cursor_shape
