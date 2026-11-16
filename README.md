# Zing
*is a performant opinionated zsh configuration for nix.*

## Try it

On any nix machine, you can run:

```sh
nix run github:jameschubbuck/Zing
```

Though you do need flakes to be enabled.

## Install

To install permanently add the following to your configuration just like any other input:

```nix
# flake.nix

inputs.zing.url = "github:jameschubbuck/Zing";

# any home-manager module

{inputs, ...}: {
  imports = [inputs.zing.homeModules.default];
  programs.zing.enable = true;
}
```

## Features

### Performance

Zing is about 4x faster than oh-my-zsh, though still 3x slower than stock zsh. In practice, the difference to stock zsh is sub 10ms, which is generally trivial.

Speed is derived from many optimizations. To name a few:

- Byte-compile plugins and `.zshrc` at build time.
- Completions from cache.
- No framework or plugin manager, aside from the magic of Nix.

*(Tested `hyperfine 'zsh -i -c exit'` on 7840HS & zsh 5.9).*

### Suggestions

Grey inline suggestions are provided while you type, just like in most word processing programs. Tab completes suggestions when a suggestion is active, or behaves normally when one isn't. Backspace can undo whole suggestions at a time.

### Syntax highlighting

Lines are colored from ANSI colors as typed. This can help unknown commands (typos) reveal themselves before they are even ran.

### Prompt

The prompt is always placed at the bottom row of the terminal. This means your focus can stay in one place, as opposed to tracking accross the screen as history grows. Of course, `clear` and `ctrl+L` are supported

The prompt also only provides directory information for the *active* prompt, i.e., it shrinks in the style of other "transient" prompts.

### Vi mode

As all text areas should, the prompt supports vimlike motions, including normal mode, which is indicated by the `»` flipping around to `«`.


### Expansion

Alias expand before execution, so you can see what actually ran and history can save the full command. In the style of [puffer fish](https://github.com/nickeb96/puffer-fish), typing `...` becomes `../..`.

### Nix integration

`nix develop`, `nix shell` and `nix-shell` drop you into zsh instead of bash.

### Colors

Zing uses your terminal's ANSI colours to match whatever theme your
terminal is already using. [Stylix](https://github.com/nix-community/stylix) is a great option for theming.
