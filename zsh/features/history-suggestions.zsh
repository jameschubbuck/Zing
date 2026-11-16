# `zing_prefix_history` strategy for `./autosuggestions.zsh`
# Suggest history, shorter forms of a command first
# With `foo` and `foo --bar`, `fo` suggests `foo`, then `foo --bar`
# Builds on the plugin's own history strategy, an internal of 0.7.1

_zsh_autosuggest_strategy_zing_prefix_history() {
  _zsh_autosuggest_strategy_history "$1"
  local recent=$suggestion
  [[ -n $recent ]] || return

  local -a matches=(${(M)history:#${(b)1}?*})
  local -i i
  for (( i = $#1 + 1; i < $#recent; i++ )); do
    [[ $recent[i+1] == ' ' && $recent[i] != ' ' ]] || continue
    if (( ${matches[(Ie)${recent[1,i]}]} )); then
      suggestion=${recent[1,i]}
      return
    fi
  done
}
