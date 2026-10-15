# `nix run`: a zsh with Zing, leaving your own config and history alone
{
  lib,
  writeShellApplication,
  zsh,
  coreutils,
  zsh-autosuggestions,
  zsh-syntax-highlighting,
  zing,
}:
writeShellApplication {
  name = "zing";
  runtimeInputs = [zsh coreutils];
  text = ''
    # $ZING_DEMO_DIR to keep the history and caches between runs
    if [[ -n ''${ZING_DEMO_DIR:-} ]]; then
      dir=$ZING_DEMO_DIR
      mkdir -p "$dir"
    else
      dir=$(mktemp -d)
      trap 'rm -rf "$dir"' EXIT
    fi
    cat > "$dir/.zshrc" <<RC
    ${lib.concatLines [
      "zstyle ':zing:plugins' zsh-autosuggestions ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "zstyle ':zing:plugins' zsh-syntax-highlighting ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      "zstyle ':zing:history' file $dir/history"
      "zstyle ':zing:compinit' cache-dir $dir/cache"
    ]}
    [[ -r $dir/zshrc.local ]] && source $dir/zshrc.local
    source ${zing}/share/zing/zing.zsh
    RC
    # NixOS's /etc/zshrc would set a prompt and run compinit of its own
    ZDOTDIR=$dir NOSYSZSHRC=1 XDG_CACHE_HOME=$dir/cache zsh -i "$@"
  '';
}
