# zstyles pointing Zing at the plugins, byte-compiled at build time
# zsh prefers foo.zsh.zwc if not older, and store paths share one timestamp
# Copies each whole package, as plugins find their pieces via `${0:A:h}`
{
  runCommandLocal,
  zsh,
  zsh-autosuggestions,
  zsh-syntax-highlighting,
}: let
  zcompile = pkg:
    runCommandLocal "${pkg.name}-zwc" {} ''
      cp -r ${pkg} $out
      chmod -R u+w $out
      find $out -name '*.zsh' \
        -exec ${zsh}/bin/zsh -fc 'zcompile -R -- "$1"' zsh {} \;
    '';
in ''
  zstyle ':zing:plugins' zsh-autosuggestions ${zcompile zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  zstyle ':zing:plugins' zsh-syntax-highlighting ${zcompile zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
''
