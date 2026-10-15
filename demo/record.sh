#!/usr/bin/env bash
# Re-record ./demo.gif and ./demo.mp4 from ./demo.tape, with vhs, in a
# throwaway home holding a small project and some history
set -euo pipefail
cd "$(dirname "$0")"

zing=$(nix build --no-link --print-out-paths ..#demo)/bin
vhs=$(nix build --no-link --print-out-paths nixpkgs#vhs)/bin

home=$(mktemp -d)
trap 'rm -rf "$home"' EXIT

# A project, with one uncommitted change for `git status` to show
mkdir -p "$home/project/src"
cd "$home/project"
cat > flake.nix <<'NIX'
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  outputs = {nixpkgs, ...}: {
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.hello;
  };
}
NIX
echo '{"nodes": {}, "root": "root", "version": 7}' > flake.lock
printf 'fn main() {\n    println!("hello");\n}\n' > src/main.rs
printf '# project\n\nA small example.\n' > README.md
git init -q
git add -A
git -c user.name=demo -c user.email=demo@example.com commit -qm 'Initial commit'
printf '# project\n\nA small example, with zing.\n' > README.md
git add README.md
git -c user.name=demo -c user.email=demo@example.com commit -qm 'Mention zing'
printf '\nBuild with `nix build`.\n' >> README.md
cd - >/dev/null

# History to suggest from, newest last
mkdir -p "$home/.zing"
printf ': %s:0;%s\n' \
  1 'nix build' \
  2 'git status' \
  3 'cargo build --release' \
  4 'git status --short' \
  5 'git log' \
  > "$home/.zing/history"

# The palette ZorrOS's stylix gives it, Catppuccin Mocha
# Captions are comments, kept out of history so they suggest nothing
cat > "$home/.zing/zshrc.local" <<'ZSH'
zstyle ':zing:theme' base03 6c7086
zstyle ':zing:theme' base04 a6adc8
zstyle ':zing:theme' base08 f38ba8
zstyle ':zing:theme' base09 fab387
zstyle ':zing:theme' base0B a6e3a1
zstyle ':zing:theme' base0C 94e2d5
zstyle ':zing:theme' base0D 89b4fa
zstyle ':zing:theme' base0E cba6f7
alias gl='git log --oneline --graph'
zshaddhistory() { [[ $1 != \#* ]] }
ZSH

HOME=$home ZING_DEMO_DIR=$home/.zing PATH=$zing:$vhs:$PATH vhs demo.tape
