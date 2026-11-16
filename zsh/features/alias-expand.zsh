# Expand an alias on enter, so the expansion is shown and saved
# Command word only, where zsh expands aliases anyway
zing-enabled alias-expand || return

_zing_expand_alias_and_accept() {
  local -a words=(${(z)BUFFER})
  local first=$words[1]
  if [[ -n $first && -n ${aliases[$first]} && $BUFFER == "$first"* ]]; then
    BUFFER=${aliases[$first]}${BUFFER#"$first"}
    CURSOR=$#BUFFER
  fi
  zle accept-line
}
zle -N _zing_expand_alias_and_accept
bindkey -M viins '^M' _zing_expand_alias_and_accept
bindkey -M viins '^J' _zing_expand_alias_and_accept
bindkey -M vicmd '^M' _zing_expand_alias_and_accept
bindkey -M vicmd '^J' _zing_expand_alias_and_accept
