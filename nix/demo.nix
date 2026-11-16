# `nix run`: a zsh with Zing, leaving your own config and history alone
{
  callPackage,
  writeShellApplication,
  zsh,
  coreutils,
  zing,
}:
writeShellApplication {
  name = "zing";
  runtimeInputs = [zsh coreutils];
  text = ''
    dir=$(mktemp -d)
    trap 'rm -rf "$dir"' EXIT
    cat > "$dir/.zshrc" <<RC
    ${callPackage ./plugins.nix {}}
    zstyle ':zing:history' file $dir/history
    zstyle ':zing:compinit' cache-dir $dir/cache
    source ${zing}/share/zing/zing.zsh
    RC
    # NixOS's /etc/zshrc would set a prompt and run compinit of its own
    ZDOTDIR=$dir NOSYSZSHRC=1 XDG_CACHE_HOME=$dir/cache zsh -i "$@"
  '';
}
