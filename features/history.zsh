zing-enabled history || return

# `zstyle ':zing:history' file`, else $HISTFILE if already set, else XDG
() {
  local file
  zstyle -s ':zing:history' file file || file=$HISTFILE
  [[ -n $file ]] || file=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history
  [[ -d ${file:h} ]] || zf_mkdir -p ${file:h}
  HISTFILE=$file
}

# Small in memory, as suggestions scan it every keystroke
# ~0.11ms per 1000 entries, the file keeps the rest
HISTSIZE=5000
SAVEHIST=200000

# No duplicates, for better suggestions
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY HIST_FCNTL_LOCK

# Keep "most recent match" per terminal
setopt NO_SHARE_HISTORY

# Save each command as it finishes, trimmed of extra blanks
setopt NO_APPEND_HISTORY INC_APPEND_HISTORY_TIME HIST_REDUCE_BLANKS
