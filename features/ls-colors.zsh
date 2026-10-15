# Set $LS_COLORS, also used by completion menus
# Kept if already set, as by a parent shell or the system
zing-enabled ls-colors || return
[[ -n $LS_COLORS ]] && return

# `zstyle ':zing:ls-colors' file` for a prebuilt one, as from Nix
() {
  local file dircolors line
  if zstyle -s ':zing:ls-colors' file file; then
    source $file
    return
  fi

  dircolors=${commands[dircolors]:-$commands[gdircolors]}
  [[ -n $dircolors ]] || return

  # Cached, as running dircolors is a fork every shell
  # Keyed on the binary, so an upgrade rebuilds it
  file=${XDG_CACHE_HOME:-$HOME/.cache}/zing/ls-colors.zsh
  [[ -r $file ]] && read -r line < $file
  if [[ $line != "# ${dircolors:A}" ]]; then
    [[ -d ${file:h} ]] || zf_mkdir -p ${file:h}
    { print -r -- "# ${dircolors:A}"; $dircolors -b } >| $file
  fi
  source $file
}
