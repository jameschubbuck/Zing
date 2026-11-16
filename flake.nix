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

    homeModules.default = ./nix/hm-module.nix;

    # Phase positions in .zshrc, for placing your own `initContent` around them
    lib.order = import ./nix/order.nix;

    formatter = forAll (pkgs: pkgs.alejandra);
  };
}
