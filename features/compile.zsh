# Byte-compile Zing and its plugins, so the next shell skips parsing them
# zsh prefers foo.zsh.zwc when it is not older than foo.zsh
# Checks are stats only, and the fork happens only when something is stale
# Unneeded under Nix, where the package is compiled at build time
zing-enabled compile || return

() {
  local -a files=($ZING_ROOT/*.zsh $ZING_ROOT/features/*.zsh) stale
  local name file
  for name in zsh-autosuggestions zsh-syntax-highlighting; do
    _zing_plugin $name 2>/dev/null || continue
    files+=(${REPLY:h}/*.zsh(N) ${REPLY:h}/highlighters/*/*.zsh(N))
  done
  for file in $files; do
    [[ -w ${file:h} && ( ! -e $file.zwc || $file -nt $file.zwc ) ]] && stale+=($file)
  done
  (( $#stale )) || return
  (
    for file in $stale; do
      zcompile -R -- $file
    done
  ) &>/dev/null &!
}
