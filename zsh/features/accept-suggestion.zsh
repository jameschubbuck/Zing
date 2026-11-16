# Tab accepts the suggestion, or completes without one
# Backspace undoes accepted suggestions whole, newest first
# Named _* so zsh-autosuggestions ignores them, hence the manual fetches

# `start:end` of each accepted suggestion
typeset -ga _zing_accept_stack

_zing_tab() {
  if [[ -n $POSTDISPLAY ]] && (( CURSOR == $#BUFFER )); then
    _zing_accept_stack+=("$#BUFFER:$(($#BUFFER + $#POSTDISPLAY))")
    zle autosuggest-accept
    _zing_refetch
  else
    zle expand-or-complete
  fi
}
zle -N _zing_tab
bindkey -M viins '^I' _zing_tab

# Only undoes if nothing was typed since
_zing_backspace() {
  if (( $#_zing_accept_stack )); then
    local range=$_zing_accept_stack[-1]
    local -i start=${range%%:*} end=${range##*:}
    if (( CURSOR == end && $#BUFFER == end )); then
      BUFFER=$BUFFER[1,start]
      CURSOR=$#BUFFER
      _zing_accept_stack[-1]=()
      _zing_refetch
      return
    fi
  fi
  zle backward-delete-char
  _zing_refetch
}
zle -N _zing_backspace
bindkey -M viins '^?' _zing_backspace
bindkey -M viins '^H' _zing_backspace

_zing_clear_accept_stack() { _zing_accept_stack=() }
add-zle-hook-widget zle-line-init _zing_clear_accept_stack
