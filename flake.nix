# Zing, for Nix: the package, a home-manager module, and `nix run` to try it
# Everything else is plain zsh, see ./README.md
{
  description = "A zsh configuration: suggestions, a bottom prompt, vi mode.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAll = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = forAll (pkgs: rec {
      zing = pkgs.callPackage ./nix/package.nix {};
      demo = pkgs.callPackage ./nix/demo.nix {inherit zing;};
      default = zing;
    });

    apps = forAll (pkgs: {
      default = {
        type = "app";
        program = nixpkgs.lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.demo;
        meta.description = "A zsh with Zing, leaving your own config and history alone";
      };
    });

    homeManagerModules.default = ./nix/hm-module.nix;

    # Phase positions in .zshrc, for placing your own `initContent` around them
    lib.order = import ./nix/order.nix;

    # The pty tests, against the package and nixpkgs' plugins
    checks = forAll (pkgs: let
      inherit (pkgs.stdenv.hostPlatform) system;
      zcompile = pkgs.callPackage ./nix/zcompile.nix {};
      autosuggestions = zcompile pkgs.zsh-autosuggestions;
      syntaxHighlighting = zcompile pkgs.zsh-syntax-highlighting;
    in {
      widgets =
        pkgs.runCommand "zing-widgets" {
          nativeBuildInputs = [pkgs.zsh];
          ZING_TEST_RC = ''
            zstyle ':zing:plugins' zsh-autosuggestions ${autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
            zstyle ':zing:plugins' zsh-syntax-highlighting ${syntaxHighlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            source ${self.packages.${system}.zing}/share/zing/zing.zsh
          '';
        } ''
          HOME=$TMPDIR zsh ${./tests/run.zsh}
          touch $out
        '';
    });

    formatter = forAll (pkgs: pkgs.alejandra);
  };
}
