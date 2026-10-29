# Zing

A zsh configuration: suggestions from paths and history, a prompt that starts
on the bottom row and shrinks once submitted, vi mode, and fast startup. For
Nix: a home-manager module that takes its colours from stylix.

![Zing's features, one caption each](demo/demo.gif)

([mp4](demo/demo.mp4), recorded by [`demo/record.sh`](demo/record.sh))

## Try it

With Nix, from a clone, without touching your own config or history:

```sh
nix run .
```

## Install

```nix
# flake.nix
inputs.zing = {
  url = "git+file:///path/to/zing"; # or its git URL
  inputs.nixpkgs.follows = "nixpkgs";
};

# a home-manager module
{inputs, ...}: {
  imports = [inputs.zing.homeManagerModules.default];
  programs.zing.enable = true;
}
```

The module:

- Takes the plugins, [zsh-autosuggestions] and [zsh-syntax-highlighting], from
  nixpkgs. Zing calls into zsh-autosuggestions' internals, so a version other
  than 0.7 may not work.
- Byte-compiles everything at build time.
- Bakes `$LS_COLORS` in.
- Uses `programs.zsh.history` for history, with Zing's settings as defaults.
- Takes `stylix`'s palette when stylix is enabled.

| Option | |
|---|---|
| `programs.zing.colors` | base16 colours, e.g. `{base0D = "89b4fa";}`, stylix's by default |
| `programs.zing.disable` | features to leave out, e.g. `["bottom-prompt"]` |
| `programs.zing.compileZshrc` | byte-compile `.zshrc` on activation, default on |

Zing runs its own `compinit` and sets up vi mode, so it replaces a framework
like oh-my-zsh or prezto rather than going alongside one.

[zsh-autosuggestions]: https://github.com/zsh-users/zsh-autosuggestions
[zsh-syntax-highlighting]: https://github.com/zsh-users/zsh-syntax-highlighting

Each phase lands at a fixed place in `.zshrc`, exported as
`inputs.zing.lib.order`. Widgets the plugins should wrap belong before
`order.late`:

```nix
programs.zsh.initContent = lib.mkOrder (inputs.zing.lib.order.late - 1) ''
  source ${zoxideInit}
'';
```

## Features

Each is a file in [`features/`](features), and each can be turned off:

```zsh
zstyle ':zing:bottom-prompt' enabled no
```

| Feature | |
|---|---|
| `autosuggestions` | Grey suggestion of the rest of the line, refetched every word |
| `path-suggestions` | Suggests paths, stopping where candidates diverge: with `flake.lock` and `flake.nix`, `cat f` suggests `cat flake.` |
| `history-suggestions` | Suggests history, shorter forms first: with `foo` and `foo --bar`, `fo` suggests `foo`, then `foo --bar` |
| `accept-suggestion` | Tab accepts the suggestion, or completes without one. Backspace right after takes the whole suggestion back |
| `syntax-highlighting` | Colours the line as it is typed, in the theme's colours |
| `prompt` | The directory above a `>`, with a blank line between commands |
| `transient-prompt` | Submitted prompts shrink to their last line, so scrollback reads as commands. Works with any multi-line `$PROMPT` |
| `bottom-prompt` | A new terminal's first prompt starts on the bottom row |
| `clear` | `clear`, `reset` and Ctrl+L clear the scrollback too, keeping the prompt at the bottom |
| `alias-expand` | Enter expands an alias, so the expansion is shown and saved |
| `dot-expand` | `...` becomes `../..` as you type |
| `auto-cd` | A directory alone is `cd`, pushing onto the directory stack |
| `vi-mode` | Vi keys, with no delay on Escape |
| `cursor` | A block cursor in command mode, a beam in insert mode, and hidden until the prompt is up |
| `keybinds` | Home, End, Delete, Ctrl+arrows, and Emacs keys (Ctrl+A, E, K, U, W, P, N) in insert mode. Ctrl+S and Ctrl+Q freed from flow control |
| `completion` | A menu with case-insensitive, mid-word matching |
| `compinit` | Completions from a dump, rebuilt in the background only when `$fpath` changes |
| `history` | Big history file, small in-memory history, no duplicates, saved as each command finishes, not shared between terminals |
| `ls-colors` | `$LS_COLORS` from `dircolors`, cached, unless already set |
| `shell-integration` | OSC 7 (directory), OSC 2 (title), OSC 133 (prompt marks and exit status), for jumping between prompts and command notifications. Turn off your terminal's own, or the marks double up |
| `nix-shells` | `nix develop`, `nix shell` and `nix-shell` drop into zsh, not bash |
| `options` | `EXTENDED_GLOB`, `INTERACTIVE_COMMENTS`, `NO_BEEP` |

## Theme

Colours are [base16] slots. Each defaults to an ANSI colour, so Zing follows
your terminal's palette until told otherwise. Values can be hex, with or
without `#`, or ANSI numbers.

```zsh
zstyle ':zing:theme' base0D '#89b4fa'
```

| Slot | Default | Used for |
|---|---|---|
| `base03` | 8, bright black | suggestions, comments |
| `base04` | 7, white | path separators |
| `base08` | 1, red | unknown commands, bracket errors |
| `base09` | 3, yellow | interpolations in strings, assignments |
| `base0B` | 2, green | aliases |
| `base0C` | 6, cyan | options, globs, third bracket level |
| `base0D` | 4, blue | the directory, paths, first bracket level |
| `base0E` | 5, magenta | the `>`, keywords, second bracket level |

[base16]: https://github.com/tinted-theming/home

## Settings

| zstyle | |
|---|---|
| `':zing:<feature>' enabled no` | turn a feature off |
| `':zing:theme' <slot> <colour>` | a colour, above |
| `':zing:history' file <path>` | history file, else `$HISTFILE` if set, else `$XDG_DATA_HOME/zsh/history` |
| `':zing:compinit' cache-dir <dir>` | where the completion dump goes, else `$XDG_CACHE_HOME/zsh` |
| `':zing:ls-colors' file <path>` | a prebuilt `dircolors -b` to source |
| `':zing:plugins' <plugin> <file>` | a plugin's entry file, e.g. `zsh-autosuggestions`; set by the module |
| `':zing:nix-shells' shell <path>` | the shell nix drops into, else this one |

## Phases

The module sources five phases, each at its place in `.zshrc`. `zing.zsh`
sources all five in a row, for `nix run`:

| Phase | |
|---|---|
| `env.zsh` | hides the cursor; can go in `.zshenv` |
| `early.zsh` | `$LS_COLORS`, `compinit` |
| `main.zsh` | options and widgets; before your own widgets, to override its bindings |
| `late.zsh` | the plugins, after every widget |
| `prompt.zsh` | the prompt, then moves it to the bottom row |

## Development

```sh
nix flake check     # drives a real zsh through a pty
demo/record.sh      # re-records demo/demo.gif and demo/demo.mp4
```

Tested on zsh 5.9, on Linux. The Darwin outputs evaluate but are untested.
