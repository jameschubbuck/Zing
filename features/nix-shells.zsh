# Drop nix shells into zsh rather than bash, unless given a command
zing-enabled nix-shells || return
(( $+commands[nix] || $+commands[nix-shell] )) || return

# This shell's own binary, `zstyle ':zing:nix-shells' shell` to change it
() {
  local shell
  zstyle -s ':zing:nix-shells' shell shell ||
    shell=${${:-/proc/$$/exe}:A}
  [[ -x $shell ]] || shell=${commands[zsh]:-zsh}
  typeset -g _zing_nix_shell=$shell
}

nix() {
  if [[ $1 == (develop|shell) && -z ${@[(r)(-c|--command)]} ]]; then
    command nix "$@" --command $_zing_nix_shell
  else
    command nix "$@"
  fi
}

nix-shell() {
  if [[ -z ${@[(r)(--run|--command|--exec)]} ]]; then
    command nix-shell "$@" --run $_zing_nix_shell
  else
    command nix-shell "$@"
  fi
}
