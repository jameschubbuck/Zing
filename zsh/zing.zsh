# Zing, all of it, for `nix run` and the tests
# The home-manager module sources each phase at its own place in .zshrc instead
for _zing_phase in env early main late prompt; do
  source ${${(%):-%x}:A:h}/$_zing_phase.zsh
done
