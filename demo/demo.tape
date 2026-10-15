# Zing's features, one caption each, see ./record.sh

Output demo.gif
Output demo.mp4

Require zing

Set Shell "bash"
Set FontFamily "Geist Mono"
Set FontSize 22
Set Width 1280
Set Height 760
Set Padding 28
Set Theme "Catppuccin Mocha"
Set TypingSpeed 70ms
Set CursorBlink false

Hide
Type "cd ~/project && exec zing"
Enter
Sleep 2.5s
Show
Sleep 1.5s

# The first prompt starts on the bottom row
Type "# Path suggestions stop where files differ, Tab accepts"
Sleep 600ms
Enter
Type "cat f"
Sleep 1.5s
Tab
Sleep 1s
Type "n"
Sleep 1.2s
Tab
Sleep 1s
Enter
Sleep 2s

Type "# Backspace takes a whole suggestion back"
Sleep 600ms
Enter
Type "cat s"
Sleep 1.2s
Tab
Sleep 1.2s
Backspace
Sleep 1.5s
Ctrl+U
Sleep 500ms

Type "# History suggests shorter commands first"
Sleep 600ms
Enter
Type "git st"
Sleep 1.5s
Tab
Sleep 800ms
Type " "
Sleep 1.5s
Tab
Sleep 800ms
Enter
Sleep 2s

Type "# Aliases expand as they run, so scrollback shows what ran"
Sleep 600ms
Enter
Type "gl"
Sleep 1s
Enter
Sleep 2s

Type "# A directory alone is cd, and dots expand"
Sleep 600ms
Enter
Type "src"
Sleep 800ms
Enter
Sleep 1s
Type "..."
Sleep 1.2s
Enter
Sleep 1s
Type "project"
Sleep 800ms
Enter
Sleep 1.5s

Type "# Highlighting as you type"
Sleep 600ms
Enter
Type `for f in *.nix; do echo "$f: $(wc -l < $f) lines"; done # Count`
Sleep 1.5s
Enter
Sleep 2s

Type "# Completion ignores case and matches mid-word"
Sleep 600ms
Enter
Type "cat read"
Sleep 1s
Tab
Sleep 1.2s
Enter
Sleep 2s

Type "# Escape for vi mode, with a block cursor"
Sleep 600ms
Enter
Type "echo hello world"
Sleep 800ms
Escape
Sleep 1s
Type "b"
Sleep 800ms
Type "cw"
Sleep 500ms
Type "zing"
Sleep 800ms
Escape
Sleep 800ms
Enter
Sleep 2s

Type "# Ctrl+L clears, and the prompt stays at the bottom"
Sleep 600ms
Enter
Sleep 800ms
Ctrl+L
Sleep 3s
