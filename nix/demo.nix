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
    dir=$(mktemp -d)
    trap 'rm -rf "$dir"' EXIT
    cat > "$dir/.zshrc" <<RC
    ${lib.concatLines [
      "zstyle ':zing:plugins' zsh-autosuggestions ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      "zstyle ':zing:plugins' zsh-syntax-highlighting ${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      "zstyle ':zing:history' file $dir/history"
      "zstyle ':zing:compinit' cache-dir $dir/cache"
    ]}
    source ${zing}/share/zing/zing.zsh
    RC
    # NixOS's /etc/zshrc would set a prompt and run compinit of its own
    ZDOTDIR=$dir NOSYSZSHRC=1 XDG_CACHE_HOME=$dir/cache zsh -i "$@"
  '';
}
