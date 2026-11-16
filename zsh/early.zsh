# Phase 2, before anything reads $LS_COLORS or completions
source ${${(%):-%x}:A:h}/lib.zsh

for _zing_feature in ls-colors compinit; do
  zing-enabled $_zing_feature && source $ZING_ROOT/features/$_zing_feature.zsh
done
