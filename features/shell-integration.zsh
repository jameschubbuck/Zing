# Shell integration via escape sequences, readable by any terminal
# Disable your terminal's own, or the marks are doubled
# All builtin printf, no forks
zing-enabled shell-integration || return

# OSC 7: working directory, for new windows
_zing_osc_cwd() { printf '\e]7;file://%s%s\e\\' "$HOST" "$PWD" }

# OSC 2: window title
_zing_osc_title() { printf '\e]2;%s\e\\' "${1:-$PWD}" }

# OSC 133: prompt, input and output marks, and exit status
# For jumping between prompts and notifying when commands finish
# A D without a C, as after an empty line, notifies nothing
_zing_osc_precmd() {
  printf '\e]133;D;%d\e\\' $?
  _zing_osc_cwd
  _zing_osc_title
  printf '\e]133;A\e\\'
}
_zing_osc_preexec() {
  _zing_osc_title "$1"
  printf '\e]133;C\e\\'
}
add-zsh-hook precmd _zing_osc_precmd
add-zsh-hook preexec _zing_osc_preexec

# Input begins once the prompt is drawn and zle starts
_zing_osc_line_start() { printf '\e]133;B\e\\' }
add-zle-hook-widget zle-line-init _zing_osc_line_start
