# Phase 3, options and widgets
# Before your own widgets, so they can override the bindings here
source ${${(%):-%x}:A:h}/lib.zsh

# suggest-refetch binds every printable key, so goes before the per-key
# bindings, which override part of its range
for _zing_feature in options vi-mode history suggest-refetch keybinds \
  completion accept-suggestion alias-expand clear cursor dot-expand \
  history-suggestions path-suggestions transient-prompt nix-shells; do
  zing-enabled $_zing_feature && source $ZING_ROOT/features/$_zing_feature.zsh
done
