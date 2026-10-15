# Phase 4, plugins that wrap every widget, so after all of them
source ${${(%):-%x}:A:h}/lib.zsh

source $ZING_ROOT/features/autosuggestions.zsh
# Last, as its own docs ask
source $ZING_ROOT/features/syntax-highlighting.zsh
