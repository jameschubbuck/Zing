zing-enabled completion || return

() {
  _zing_completion_cache
  local cache=$REPLY

  # Menu with case-insensitive, substring matching
  zstyle ':completion:*' menu select
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' special-dirs true
  zstyle ':completion:*' squeeze-slashes true
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path $cache/zcompcache
  # Find newly installed commands without a rehash
  zstyle ':completion:*' rehash true
}

# Complete mid-word, then jump to the end
setopt COMPLETE_IN_WORD ALWAYS_TO_END
