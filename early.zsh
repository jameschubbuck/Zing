# Phase 2, before anything reads $LS_COLORS or completions
source ${${(%):-%x}:A:h}/lib.zsh

source $ZING_ROOT/features/ls-colors.zsh
source $ZING_ROOT/features/compinit.zsh
