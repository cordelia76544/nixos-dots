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

      # 安全 rm
      def rm [...args] {
        if ($args | is-empty) {
          print "rm: missing operand"
          return
        }

        if ($args | any {|x| $x == "-r" or $x == "--recursive"}) {
          print "⚠️ recursive delete → moved to trash"
        }

        ^rip ...$args
      }

      # 真删除
      def real-rm [...args] {
        if ($args | is-empty) {
          print "real-rm: missing operand"
          return
        }

        print "⚠️ Permanently delete? (y/N)"
        let confirm = (input)

        if ($confirm | str downcase) == "y" {
          ^rm ...$args
        } else {
          print "Cancelled"
        }
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
}
