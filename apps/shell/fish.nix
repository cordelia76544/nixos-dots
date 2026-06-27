{pkgs, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -alh --icons=always";
      ls = "eza --icons=always";
    };

    shellAbbrs = {
      update = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      sduo = "sudo";
    };

    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "fish-you-should-use";
        src = pkgs.fishPlugins.fish-you-should-use.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    functions = {
      opencode = {
        description = "Run OpenCode in rootful Podman";
        body = ''
          sudo podman run --rm -it \
            --user (id -u):(id -g) \
            -e HOME=/home/opencode \
            -v "$HOME/Documents/opencode/workspace:/workspace:Z" \
            -v "$HOME/Documents/opencode/home:/home/opencode:Z" \
            -w /workspace \
            ghcr.io/anomalyco/opencode:latest $argv
        '';
      };
    };

    # 初始化配置
    interactiveShellInit = ''
      # 禁用每次打开终端的默认欢迎语
      set -g fish_greeting ""


      # 禁用 z.lua 的默认初始化以提升速度
      # set -x ZLUA_SCRIPT "...path..."
    '';

    # sessionVariables = { ... };
  };

  # Starship 提示符
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  #xdg.configFile."starship.toml".source = ./starship.toml;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.direnv.enableFishIntegration = true;
  programs.kitty.shellIntegration.enableFishIntegration = true;
  programs.yazi.enableFishIntegration = true;
  programs.zoxide.enableFishIntegration = true;
}
