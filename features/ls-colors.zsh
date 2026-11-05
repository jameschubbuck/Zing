# Set $LS_COLORS, also used by completion menus
# Kept if already set, as by a parent shell or the system
# Directories others can write, or sticky ones, as any other directory, not
# dircolors' blue on green and white on blue, which are hard to read
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
  # Keyed on the binary and on how it is made, so either changing rebuilds it
  file=${XDG_CACHE_HOME:-$HOME/.cache}/zing/ls-colors.zsh
  [[ -r $file ]] && read -r line < $file
  if [[ $line != "# ${dircolors:A} plain-dirs" ]]; then
    [[ -d ${file:h} ]] || zf_mkdir -p ${file:h}
    setopt local_options extended_glob
    {
      print -r -- "# ${dircolors:A} plain-dirs"
      print -rl -- ${${(f)"$($dircolors -p)"}/(#b)(#s)(STICKY_OTHER_WRITABLE|OTHER_WRITABLE|STICKY) */$match[1] 01;34} \
        | $dircolors -b -
    } >| $file
  fi
  source $file
}
