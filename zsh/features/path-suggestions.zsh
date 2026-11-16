# `zing_path` strategy for `./autosuggestions.zsh`
# Suggest paths, stopping where the candidates diverge
# With flake.lock and flake.nix, `cat f` suggests `cat flake.`

# Longest common prefix of the arguments, in $REPLY
_zing_common_prefix() {
  REPLY=$1
  shift
  local candidate
  for candidate; do
    while [[ ${candidate[1,$#REPLY]} != "$REPLY" ]]; do
      REPLY=${REPLY[1,-2]}
    done
  done
}

# Path to glob for the current word, in $REPLY
# Skips bare directories, slow to read, /nix/store/ takes ~45ms
_zing_path_stem() {
  local word=$1
  [[ $word == -* || $word == [\'\"]* || $word == *[*?\[\]\$\`]* ]] && return 1
  [[ $word == */ ]] && return 1

  if [[ $word == '~/'* ]]; then
    REPLY=$HOME/${word#'~/'}
  else
    REPLY=$word
  fi
}

_zsh_autosuggest_strategy_zing_path() {
  typeset -g suggestion=
  local buf=$1
  [[ $buf == *[^[:space:]] ]] || return

  # Leave the command word to history, and comments alone
  local -a words=(${(z)buf})
  (( $#words > 1 )) || return
  [[ $words[1] == \#* ]] && return

  local last=$words[-1] stem
  _zing_path_stem "$last" || return
  stem=$REPLY

  local -a matches=(${stem}*(N))
  (( $#matches )) || return

  local match
  if (( $#matches == 1 )); then
    match=$matches[1]
    [[ -d $match ]] && match+=/
  else
    _zing_common_prefix "$matches[@]"
    match=$REPLY
  fi

  # Keep ~ literal, so it still expands when run
  local head=""
  [[ $last == '~/'* ]] && { head='~/'; match=${match#$HOME/} }

  suggestion=${buf[1,$#buf - $#last]}$head${(q-)match}
  # Drop suggestions that don't extend the buffer, e.g. from quoting
  [[ $suggestion == "$buf"?* ]] || suggestion=
}
