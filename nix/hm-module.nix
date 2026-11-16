# Zing for home-manager: each phase sourced at its place in .zshrc, and the
# plugins from nixpkgs
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.zing;
  order = import ./order.nix;
  zcompile = pkgs.callPackage ./zcompile.nix {};
  share = "${cfg.package}/share/zing";

  # Each file in features/, but suggest-refetch, a part of autosuggestions
  features = lib.pipe (builtins.readDir ../features) [
    builtins.attrNames
    (map (lib.removeSuffix ".zsh"))
    (lib.remove "suggest-refetch")
  ];
  enabled = feature: !(lib.elem feature cfg.disable);

  # Bake at build time instead of running dircolors every shell. Directories
  # others can write, or sticky ones, as any other directory, as
  # features/ls-colors.zsh has them
  lsColors = pkgs.runCommandLocal "ls-colors.zsh" {} ''
    ${pkgs.coreutils}/bin/dircolors -p \
      | sed -E 's/^(STICKY_OTHER_WRITABLE|OTHER_WRITABLE|STICKY) .*/\1 01;34/' \
      | ${pkgs.coreutils}/bin/dircolors -b - > $out
  '';

  # Absolute, or relative to home in older home-manager configurations
  inherit (config.programs.zsh) dotDir;
  zshrc =
    if lib.hasPrefix "/" dotDir
    then "${dotDir}/.zshrc"
    else "${config.home.homeDirectory}/${dotDir}/.zshrc";

  zstyle = context: style: value: "zstyle ${lib.escapeShellArgs [":zing${context}" style value]}";
  zstyles = lib.concatLines (
    [
      (zstyle ":plugins" "zsh-autosuggestions"
        "${zcompile pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh")
      (zstyle ":plugins" "zsh-syntax-highlighting"
        "${zcompile pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")
      (zstyle ":ls-colors" "file" "${lsColors}")
    ]
    ++ lib.mapAttrsToList (zstyle ":theme") cfg.colors
    ++ map (feature: zstyle ":${feature}" "enabled" "no") cfg.disable
    # Set through home-manager's options instead, below
    ++ [(zstyle ":history" "enabled" "no")]
  );
in {
  options.programs.zing = {
    enable = lib.mkEnableOption "Zing, a zsh configuration";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {};
      defaultText = lib.literalMD "Zing, from this flake";
      description = "Zing's zsh files.";
    };

    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        base0D = "89b4fa";
        base0E = "cba6f7";
      };
      description = ''
        base16 colours, hex with or without `#`, or ANSI numbers.
        Slots left out use the terminal's ANSI palette.
      '';
    };

    disable = lib.mkOption {
      type = lib.types.listOf (lib.types.enum features);
      default = [];
      example = ["bottom-prompt" "nix-shells"];
      description = "Features to leave out, by the names of the files in `features/`.";
    };

    compileZshrc = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Byte-compile .zshrc on activation, to skip reparsing it every shell.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      lib.optional config.programs.zsh.autosuggestion.enable
      "programs.zing: programs.zsh.autosuggestion loads the plugin a second time"
      ++ lib.optional config.programs.zsh.syntaxHighlighting.enable
      "programs.zing: programs.zsh.syntaxHighlighting loads the plugin a second time";

    programs.zsh = {
      enable = true;

      # `../features/history.zsh`, as defaults of home-manager's own options,
      # so that setting those still works
      history = lib.mkIf (enabled "history") (lib.mapAttrs (_: lib.mkDefault) {
        path = "${config.xdg.dataHome}/zsh/history";
        size = 5000;
        save = 200000;
        ignoreDups = true;
        ignoreAllDups = true;
        expireDuplicatesFirst = true;
        findNoDups = true;
        saveNoDups = true;
        ignoreSpace = true;
        extended = true;
        share = false;
      });
      setOptions = lib.mkIf (enabled "history") [
        "INC_APPEND_HISTORY_TIME"
        "HIST_REDUCE_BLANKS"
        "HIST_FCNTL_LOCK"
      ];

      # `../features/compinit.zsh` instead
      completionInit = lib.mkIf (enabled "compinit") (lib.mkDefault "");

      envExtra = lib.mkIf (enabled "cursor") ''
        source ${share}/env.zsh
      '';

      initContent = lib.mkMerge [
        (lib.mkOrder order.config zstyles)
        (lib.mkOrder order.early "source ${share}/early.zsh")
        (lib.mkOrder order.main "source ${share}/main.zsh")
        (lib.mkOrder order.late "source ${share}/late.zsh")
        (lib.mkOrder order.prompt "source ${share}/prompt.zsh")
      ];
    };

    # zsh uses .zshrc.zwc when not older than .zshrc, and every store path has
    # the same timestamp, so recompile on each activation
    home.activation.zingCompileZshrc = lib.mkIf cfg.compileZshrc (
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ${pkgs.zsh}/bin/zsh -fc 'zcompile -R -- "$1"' zsh ${lib.escapeShellArg zshrc} || true
      ''
    );
  };
}
