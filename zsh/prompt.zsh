# Phase 5, right before the first prompt
source ${${(%):-%x}:A:h}/lib.zsh

# bottom-prompt after anything that sets $PROMPT, as it reads its line count
for _zing_feature in prompt bottom-prompt; do
  zing-enabled $_zing_feature && source $ZING_ROOT/features/$_zing_feature.zsh
done
