# Load completions from a dump, rebuilt only when $fpath changes
# A full compinit takes ~1.5s on NixOS, so a changed $fpath loads the old dump
# once while a forked job writes the new one

zmodload -F zsh/stat b:zstat
autoload -Uz compinit

() {
  _zing_completion_cache
  local cache=$REPLY
  [[ -d $cache ]] || zf_mkdir -p $cache
  local dump=$cache/zcompdump

  # Where each entry resolves and when it last changed
  # Store paths never change, but the profile links into them do
  local -a dirs=(${^fpath}(N-/:A)) mtimes
  (( $#dirs )) && zstat -A mtimes +mtime -- $dirs
  local sig="$ZSH_VERSION ${dirs:^mtimes}"

  if [[ -s $dump && -r $dump.sig && "$(<$dump.sig)" == "$sig" ]]; then
    compinit -C -d $dump
    return
  fi

  # Newest first, without the compiled copies and signatures
  local -a old=($cache/zcompdump(|-*)(N.om))
  old=(${old:#*.(zwc|sig)})
  if (( ! $#old )); then
    compinit -d $dump
    zcompile -R -- $dump
    print -r -- $sig >| $dump.sig
    return
  fi

  compinit -C -d $old[1]
  # Build beside the cache, so the dump, its .zwc and signature land together
  (
    local build=$cache/build.$$
    zf_mkdir -p $build
    compinit -d $build/zcompdump
    zcompile -R -- $build/zcompdump
    print -r -- $sig > $build/zcompdump.sig
    zf_rm -f -- $old ${^old}.zwc ${^old}.sig
    zf_mv -f -- $build/zcompdump.zwc $build/zcompdump $build/zcompdump.sig $cache/
    zf_rm -rf -- $build
  ) &>/dev/null &!
}

zmodload zsh/complist
