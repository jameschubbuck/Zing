# Zing, all of it: source this at the end of .zshrc
# Set zstyles before it, and anything to override after it
# Widgets of your own go before it, so the plugins see them
# For finer placement, source the phases yourself, in this order
# Top level rather than a loop in a function, where plugins' typesets go local
source ${${(%):-%x}:A:h}/env.zsh
source ${${(%):-%x}:A:h}/early.zsh
source $ZING_ROOT/main.zsh
source $ZING_ROOT/late.zsh
source $ZING_ROOT/prompt.zsh
