# Expand ... to ../..
# Named _* so zsh-autosuggestions ignores it, hence the manual fetch
zing-enabled dot-expand || return

_zing_dot_expand() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
  _zing_refetch
}
zle -N _zing_dot_expand
bindkey -M viins . _zing_dot_expand
