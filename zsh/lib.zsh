# Helpers for every phase, sourced once
(( $+functions[zing-enabled] )) && return

typeset -g ZING_ROOT=${${(%):-%x}:A:h}

zmodload -F zsh/files b:zf_mkdir b:zf_mv b:zf_rm
autoload -Uz add-zsh-hook add-zle-hook-widget

# Whether a feature is on, unless `zstyle ':zing:<feature>' enabled no`
zing-enabled() { zstyle -T ":zing:$1" enabled }

# ANSI fallbacks for each base16 slot used, so the terminal's palette shows
# through, as in base16 terminal themes
typeset -gA _zing_ansi=(
  base03 8 # Bright black: suggestions, comments
  base04 7 # White: path separators
  base08 1 # Red: errors
  base09 3 # Yellow: interpolations
  base0B 2 # Green: aliases
  base0C 6 # Cyan: options, globs
  base0D 4 # Blue: directories, paths
  base0E 5 # Magenta: keywords, the prompt
)

# Colour for a base16 slot, for %F{} and fg=, in $REPLY
# Set with `zstyle ':zing:theme' base0D '#89b4fa'`, the # is optional
zing-color() {
  zstyle -s ':zing:theme' $1 REPLY || REPLY=$_zing_ansi[$1]
  [[ $#REPLY == 6 && $REPLY != *[^[:xdigit:]]* ]] && REPLY="#$REPLY"
}

# Line count of $PROMPT, in $REPLY
_zing_prompt_lines() {
  local newlines=${PROMPT//[^$'\n']}
  REPLY=$(( $#newlines + 1 ))
}

# Refetch the suggestion, if there is a plugin to fetch it
_zing_refetch() {
  (( $+widgets[autosuggest-fetch] )) && zle autosuggest-fetch
}

# Entry file of a plugin, in $REPLY
# `zstyle ':zing:plugins' <name> <file>`, which Nix sets, see `nix/hm-module.nix`
_zing_plugin() {
  zstyle -s ':zing:plugins' $1 REPLY && return
  print -u2 "zing: no \`zstyle ':zing:plugins' $1\`"
  return 1
}

# Completion cache directory, in $REPLY
# `zstyle ':zing:compinit' cache-dir <dir>`, else under $XDG_CACHE_HOME
_zing_completion_cache() {
  zstyle -s ':zing:compinit' cache-dir REPLY || REPLY=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
}
