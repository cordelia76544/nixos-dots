{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "eza -alh --icons=always";
      ls = "eza --icons=always";
      update = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      sduo = "sudo";
    };

    history.size = 10000;

    plugins = [
      # Aloxaf/fzf-tab
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master"; # 建議之後改成固定 commit
          hash = "sha256-S07YFyh6jKKQn8tpeTNReKLmpVxXzIF3jXCmst6B3+I=";
        };
      }
    ];

    initContent = ''

      # 补全样式设置
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      # 禁用 z.lua 的默认初始化以提升速度
      # export ZLUA_SCRIPT="...path..."
    '';

    sessionVariables = {
      #POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = "true";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.fzf.enableZshIntegration = true;
  programs.eza.enableZshIntegration = true;

  #home.file.".p10k.zsh".source = ./p10k.zsh;
}
