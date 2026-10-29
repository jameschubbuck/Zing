#!/usr/bin/env zsh
# Drive an interactive zsh with Zing through a pty, checking what each
# keystroke leaves in the line editor
# Run by `nix flake check`, which sets $ZING_TEST_RC to source Zing and its
# plugins
emulate -L zsh
setopt err_return no_unset
zmodload zsh/zpty

local tmp=$(mktemp -d)
trap "zpty -d zing 2>/dev/null; rm -rf ${(q)tmp}" EXIT

# A project to suggest paths in, and history to suggest from
mkdir -p $tmp/home $tmp/project/src
touch $tmp/project/{flake.lock,flake.nix,README.md}
print -l ': 1:0;git status' ': 2:0;git status --short' ': 3:0;git commit -m wip' \
  > $tmp/home/history

# Each ^X writes the line and the suggestion, each run command its history line
cat > $tmp/home/.zshrc <<RC
zstyle ':zing:history' file $tmp/home/history
zstyle ':zing:bottom-prompt' enabled no
$ZING_TEST_RC
alias gs='git status'
_zing_test_dump() { print -r -- "\$BUFFER|\$POSTDISPLAY" >> $tmp/out }
zle -N _zing_test_dump
bindkey '^X' _zing_test_dump
_zing_test_preexec() { print -r -- "ran:\$1" >> $tmp/out }
preexec_functions+=(_zing_test_preexec)
PROMPT='> '
RC

zpty -b zing env -i HOME=$tmp/home ZDOTDIR=$tmp/home TERM=xterm-256color \
  PATH=$PATH NOSYSZSHRC=1 COLUMNS=80 LINES=24 zsh -i
local -i failed=0

# Send keys one at a time, as typed, since the plugin skips fetching while
# input is queued
type() {
  local key
  for key in ${(s::)1}; do
    zpty -w -n zing "$key"
    sleep 0.03
  done
}

# Type keys, then ^X, and compare the newest dump
check() {
  local keys=$1 want=$2 line got
  : >| $tmp/out
  type "$keys"$'\C-x'
  for i in {1..50}; do
    zpty -rt zing line 2>/dev/null || true
    [[ -s $tmp/out ]] && break
    sleep 0.05
  done
  got=$(<$tmp/out)
  if [[ $got == "$want" ]]; then
    print -r -- "ok    ${(qqqq)keys} -> $got"
  else
    print -r -- "FAIL  ${(qqqq)keys} -> $got, want $want"
    failed+=1
  fi
  # Clear the line for the next case, then let it settle
  zpty -w -n zing $'\C-u'
  sleep 0.1
}

zpty -w -n zing "cd $tmp/project"$'\r'
sleep 1
while zpty -rt zing line 2>/dev/null; do :; done

check 'cat f' 'cat f|lake.'                           # Paths stop where they diverge
check $'cat f\t' 'cat flake.|'                        # Tab accepts
check $'cat f\tn' 'cat flake.n|ix'                    # And suggests again
check $'cat f\t\x7f' 'cat f|lake.'                    # Backspace undoes the accept
check 'cat s' 'cat s|rc/'                             # A lone directory gets its /
check '# see s' '# see s|'                            # Not in comments
check 'git st' 'git st|atus'                          # Shorter forms first, though newer
check 'cd ...' 'cd ../..|'                            # Dots expand
check $'cat F\t' 'cat flake.|'                        # Completion ignores case

# Enter expands the alias, so history records what ran
: >| $tmp/out
type $'gs\r'
sleep 0.5
if [[ $(<$tmp/out) == ran:git\ status* ]]; then
  print "ok    alias expanded to $(<$tmp/out)"
else
  print "FAIL  alias: $(<$tmp/out)"
  failed+=1
fi

(( failed == 0 ))
