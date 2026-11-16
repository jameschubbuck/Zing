# Zing's own files, byte-compiled, under share/zing
# The plugins are nixpkgs', see `./hm-module.nix`
{
  lib,
  stdenvNoCC,
  zsh,
}:
stdenvNoCC.mkDerivation {
  pname = "zing";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [../zsh ../LICENSE.md];
  };

  nativeBuildInputs = [zsh];

  installPhase = ''
    mkdir -p $out/share/zing
    cp -r zsh/. LICENSE.md $out/share/zing/
    find $out -name '*.zsh' -exec zsh -fc 'zcompile -R -- "$1"' zsh {} \;
  '';

  meta = {
    description = "A zsh configuration: suggestions, a bottom prompt, vi mode";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
