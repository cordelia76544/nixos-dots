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
      $env.config = ($env.config? | default {})

      $env.config = ($env.config
        | upsert show_banner false
        | upsert completions.case_sensitive false
        | upsert completions.quick true
        | upsert completions.partial false
        | upsert completions.algorithm "fuzzy"
        | upsert history.max_size 10000
        | upsert history.sync_on_enter true
        | upsert history.file_format "sqlite"
        | upsert edit_mode emacs
      )

      def --wrapped rm [...args] {
        ^rip ...$args
      }

      def --wrapped real-rm [...args] {
        ^rm ...$args
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

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  home.packages = with pkgs; [
    rm-improved
  ];
}
