# Phase 1, for .zshenv or the top of .zshrc
# Hide the cursor until there is a prompt to show it in, see `features/cursor.zsh`
if [[ -o interactive && -t 1 ]] && zstyle -T ':zing:cursor' enabled; then
  printf '\e[?25l'
fi
