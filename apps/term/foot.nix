{
  lib,
  osConfig,
  ...
}:
lib.mkIf (osConfig.local.wm == "hyprland") {
  programs.foot = {
    enable = true;
    server.enable = false;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        pad = "8x8";
      };

      csd.preferred = "none";

      cursor = {
        style = "beam";
        beam-thickness = 1;
      };

      mouse.hide-when-typing = "yes";
      colors-dark = {
        alpha = 0.76;
        cursor = "000000 eaeaea";

        foreground = "e7ebed";
        background = "000000";
        selection-foreground = "e7ebed";
        selection-background = "4e6a78";

        regular0 = "435b67";
        regular1 = "fc3841";
        regular2 = "5cf19e";
        regular3 = "fed032";
        regular4 = "37b6ff";
        regular5 = "fc226e";
        regular6 = "59ffd1";
        regular7 = "ffffff";

        bright0 = "a1b0b8";
        bright1 = "fc746d";
        bright2 = "adf7be";
        bright3 = "fee16c";
        bright4 = "70cfff";
        bright5 = "fc669b";
        bright6 = "9affe6";
        bright7 = "ffffff";
      };

      key-bindings = {
        # 需要下面的 OSC 133 hook 才生效
        prompt-prev = "Control+Shift+Up";
        prompt-next = "Control+Shift+Down";
      };
    };
  };

  # foot 的 shell integration：OSC 7（当前目录）+ OSC 133（提示符/输出标记）
  # 仅在 foot 内启用，避免和 Ghostty 自动注入的重复
  programs.zsh.initContent = lib.mkAfter ''
    if [[ $TERM == foot* ]]; then
      autoload -Uz add-zsh-hook

      _foot_osc7() {
        (( ZSH_SUBSHELL )) && return
        emulate -L zsh
        setopt extendedglob
        local LC_ALL=C
        printf '\e]7;file://%s%s\e\\' "$HOST" \
          "''${PWD//(#m)([^@-Z_a-z0-9.~\/-])/%''${(l:2::0:)$(([##16]#MATCH))}}"
      }

      _foot_precmd() {
        # 上一条命令输出结束 + 新提示符开始
        if (( ''${_foot_cmd_running:-0} )); then
          print -n '\e]133;D\e\\'
          _foot_cmd_running=0
        fi
        print -n '\e]133;A\e\\'
      }

      _foot_preexec() {
        # 命令输出开始（用于 pipe-command-output）
        print -n '\e]133;C\e\\'
        _foot_cmd_running=1
      }

      add-zsh-hook chpwd _foot_osc7
      add-zsh-hook precmd _foot_precmd
      add-zsh-hook preexec _foot_preexec
      _foot_osc7
    fi
  '';
}
