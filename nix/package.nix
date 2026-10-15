# Zing's own files, byte-compiled, under share/zing
# Without the plugin submodules, as Nix has its own, see `./hm-module.nix`
{
  lib,
  stdenvNoCC,
  zsh,
}: let
  root = ../.;
in
  stdenvNoCC.mkDerivation {
    pname = "zing";
    version = "0.1.0";

    src = lib.fileset.toSource {
      inherit root;
      fileset = lib.fileset.unions [
        (lib.fileset.difference
          (lib.fileset.fileFilter (file: file.hasExt "zsh") root)
          (lib.fileset.unions [(lib.fileset.maybeMissing ../plugins) ../tests]))
        ../LICENSE.md
      ];
    };

    nativeBuildInputs = [zsh];

    installPhase = ''
      mkdir -p $out/share/zing
      cp -r *.zsh features LICENSE.md $out/share/zing/
      find $out -name '*.zsh' -exec zsh -fc 'zcompile -R -- "$1"' zsh {} \;
    '';

    meta = {
      description = "A zsh configuration: suggestions, a bottom prompt, vi mode";
      # Not `lib.licenses.hl3`, which nixpkgs counts as unfree, refusing to
      # evaluate without allowUnfree; ../LICENSE.md is the licence
      platforms = lib.platforms.unix;
    };
  }
