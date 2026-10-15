# Colour the command line as it is typed
zing-enabled syntax-highlighting || return
_zing_plugin zsh-syntax-highlighting || return

source $REPLY

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Only where the plugin's defaults differ
# Its defaults are ANSI, so under a base16 terminal theme commands, strings and
# unknown tokens already match, and unset styles fall back,
# e.g. command to arg0 and path_prefix to path
() {
  local -A c
  local slot
  for slot in ${(k)_zing_ansi}; do
    zing-color $slot
    c[$slot]=fg=$REPLY
  done

  ZSH_HIGHLIGHT_STYLES+=(
    # Plain text
    redirection none
    # Anything that runs
    suffix-alias $c[base0B]
    global-alias $c[base0B]
    # Keywords and substitutions
    reserved-word $c[base0E]
    history-expansion $c[base0E]
    back-quoted-argument $c[base0E]
    # Paths
    path $c[base0D]
    path_pathseparator $c[base04]
    path_prefix_pathseparator $c[base04]
    autodirectory $c[base0D],underline
    # Options and globs
    single-hyphen-option $c[base0C]
    double-hyphen-option $c[base0C]
    globbing $c[base0C]
    # Interpolations in strings
    dollar-double-quoted-argument $c[base09]
    back-double-quoted-argument $c[base09]
    assign $c[base09]
    # Default is black, often the background
    comment $c[base03],italic
    # Errors, unbolded
    bracket-error $c[base08]
    # Brackets by depth, unbolded
    bracket-level-1 $c[base0D]
    bracket-level-2 $c[base0E]
    bracket-level-3 $c[base0C]
  )
}
