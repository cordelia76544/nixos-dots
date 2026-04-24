{
  pkgs,
  lib,
  ...
}: {
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
          hash = lib.fakeHash;
        };
        file = "fzf-tab.plugin.zsh";
      }

      # skywind3000/z.lua
      {
        name = "z.lua";
        src = pkgs.fetchFromGitHub {
          owner = "skywind3000";
          repo = "z.lua";
          rev = "master"; # 建議之後改成固定 commit
          hash = lib.fakeHash;
        };
        file = "z.lua";
      }
    ];

    initContent = ''
      # [Instant Prompt] 必须放在文件最顶端
      #if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      #  source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      #fi

      # 补全样式设置
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      ## 加载 p10k 配置
      #[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

  programs.fzf.enableZshIntegration = true;
  programs.eza.enableZshIntegration = true;

  #home.file.".p10k.zsh".source = ./p10k.zsh;
}
