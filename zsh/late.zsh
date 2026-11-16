# Phase 4, plugins that wrap every widget, so after all of them
source ${${(%):-%x}:A:h}/lib.zsh

# syntax-highlighting last, as its own docs ask
for _zing_feature in autosuggestions syntax-highlighting; do
  zing-enabled $_zing_feature && source $ZING_ROOT/features/$_zing_feature.zsh
done
