# Stop words at path separators, for ^W and word motions
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Free ^S and ^Q from pausing the terminal
setopt NO_FLOW_CONTROL

# Standard keys, which some systems set in /etc/zshrc or /etc/zinputrc
# Home and End in both application (SS3) and normal (CSI) cursor mode
bindkey -M viins '\eOH' beginning-of-line
bindkey -M viins '\eOF' end-of-line
bindkey -M viins '\e[H' beginning-of-line
bindkey -M viins '\e[F' end-of-line
bindkey -M viins '\e[1~' beginning-of-line
bindkey -M viins '\e[4~' end-of-line
bindkey -M viins '\e[3~' delete-char
bindkey -M viins '\e[2~' overwrite-mode
bindkey -M viins '\e[5~' up-line-or-history
bindkey -M viins '\e[6~' down-line-or-history
bindkey -M viins '\e[1;5C' forward-word
bindkey -M viins '\e[1;5D' backward-word

# Emacs style line editing
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
