# Phase 5, right before the first prompt
source ${${(%):-%x}:A:h}/lib.zsh

source $ZING_ROOT/features/prompt.zsh
# After anything that sets $PROMPT, as it reads its line count
source $ZING_ROOT/features/bottom-prompt.zsh
