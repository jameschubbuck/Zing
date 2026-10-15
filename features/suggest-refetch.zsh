# Part of `./autosuggestions.zsh`
# Refetch after every word, as the plugin otherwise trims its old guess
# and a history match on the command word would beat later path matches
# Named _* so the plugin ignores it, hence the manual fetch
zing-enabled autosuggestions || return

_zing_self_insert() {
  zle self-insert
  [[ $LBUFFER == *[[:space:]]* ]] && _zing_refetch
}
zle -N _zing_self_insert
bindkey -M viins -R ' -~' _zing_self_insert
