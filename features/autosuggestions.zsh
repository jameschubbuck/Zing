# Grey suggestion of the rest of the line, in insert mode at the end
# See `./path-suggestions.zsh` and `./history-suggestions.zsh`
zing-enabled autosuggestions || return
_zing_plugin zsh-autosuggestions || return
typeset -g _zing_source=$REPLY

() {
  typeset -ga ZSH_AUTOSUGGEST_STRATEGY=()
  zing-enabled path-suggestions && ZSH_AUTOSUGGEST_STRATEGY+=(zing_path)
  if zing-enabled history-suggestions; then
    ZSH_AUTOSUGGEST_STRATEGY+=(zing_prefix_history)
  else
    ZSH_AUTOSUGGEST_STRATEGY+=(history)
  fi
  zing-color base03
  typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$REPLY"
}
# Bound once here, after every widget, rather than rechecked every prompt
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=120

source $_zing_source
unset _zing_source

# `./history-suggestions.zsh` calls into the plugin, so check it is there
if (( ${ZSH_AUTOSUGGEST_STRATEGY[(I)zing_prefix_history]} && ! $+functions[_zsh_autosuggest_strategy_history] )); then
  print -u2 "zing: history suggestions need zsh-autosuggestions 0.7"
  ZSH_AUTOSUGGEST_STRATEGY=(${ZSH_AUTOSUGGEST_STRATEGY:#zing_prefix_history})
fi

# Only in insert mode with the cursor at the end, where Tab can accept it
# Elsewhere it reads as text that isn't there, so hide it, and fetch it again
# on the way back
_zing_suggestion_place() {
  if [[ $KEYMAP == vicmd ]] || (( CURSOR < $#BUFFER )); then
    [[ -n $POSTDISPLAY ]] || return
    zle autosuggest-clear
    typeset -g _zing_suggestion_hidden=1
  elif (( $+_zing_suggestion_hidden )); then
    unset _zing_suggestion_hidden
    zle autosuggest-fetch
  fi
}
add-zle-hook-widget zle-line-pre-redraw _zing_suggestion_place
