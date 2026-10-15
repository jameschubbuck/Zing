# Where the home-manager module puts each phase in .zshrc, for `lib.mkOrder`
# home-manager's own are noted for reference
{
  #  540  home-manager: localVariables
  # zstyles from the module's options, before anything reads them
  config = 560;
  #  570  home-manager: completionInit, emptied by the module
  early = 570;
  #  910  home-manager: history, whose $HISTFILE Zing keeps
  #  950  home-manager: setOptions
  main = 1000;
  #  1100 home-manager: shellAliases
  # Before here for widgets the plugins should wrap
  late = 1190;
  #  1200 home-manager: syntaxHighlighting, which Zing replaces
  prompt = 1300;
}
