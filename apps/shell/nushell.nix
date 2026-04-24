{pkgs, ...}: {
  programs.nushell = {
    enable = true;

    shellAliases = {
      ll = "eza -alh --icons=always";
      ls = "eza --icons=always";
      update = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      sduo = "sudo";
    };

    plugins = [
      pkgs.nushellPlugins.gstat
      pkgs.nushellPlugins.highlight
      pkgs.nushellPlugins.query
    ];

    configFile.text = ''
      $env.config = {
        show_banner: false

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
        }

        history: {
          max_size: 10000
          sync_on_enter: true
          file_format: "sqlite"
        }

        edit_mode: emacs
      }
    '';

    envFile.text = ''
      # 这里放原来 zsh sessionVariables 对应的环境变量
      # 例如：
      # $env.EDITOR = "nvim"
    '';
  };

  programs.eza = {
    enable = true;
    enableNushellIntegration = true;
  };
}
