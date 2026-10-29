# Phase 3, options and widgets
# Before your own widgets, so they can override the bindings here
source ${${(%):-%x}:A:h}/lib.zsh

source $ZING_ROOT/features/options.zsh
source $ZING_ROOT/features/vi-mode.zsh
source $ZING_ROOT/features/history.zsh
source $ZING_ROOT/features/auto-cd.zsh
# Before the per-key bindings, which override part of its range
source $ZING_ROOT/features/suggest-refetch.zsh
source $ZING_ROOT/features/keybinds.zsh
source $ZING_ROOT/features/completion.zsh
source $ZING_ROOT/features/accept-suggestion.zsh
source $ZING_ROOT/features/alias-expand.zsh
source $ZING_ROOT/features/clear.zsh
source $ZING_ROOT/features/cursor.zsh
source $ZING_ROOT/features/dot-expand.zsh
source $ZING_ROOT/features/history-suggestions.zsh
source $ZING_ROOT/features/path-suggestions.zsh
source $ZING_ROOT/features/transient-prompt.zsh
source $ZING_ROOT/features/nix-shells.zsh
