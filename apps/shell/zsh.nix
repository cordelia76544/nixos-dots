{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # fish 的 shellAliases 直接对应
    shellAliases = {
      ll = "eza -alh --icons=always";
      ls = "eza --icons=always";
      # fish 的 shellAbbrs 在 zsh 里没有原生等价物，降级为别名
      # 想要真正的缩写展开，见文件末尾关于 zsh-abbr 的说明
      update = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      upgrade = "sudo nixos-rebuild boot --flake ~/nixos#nixos";
      sduo = "sudo";
    };

    # compinit 缓存：24 小时才完整重建一次，其余时间走缓存
    completionInit = ''
      autoload -Uz compinit
      if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit
      else
        compinit -C
      fi
    '';

    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    plugins = [
      # fish-you-should-use 的 zsh 对应物
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      # fzf-fish 的补全菜单部分（fzf 本身的快捷键由 programs.fzf 提供）
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      # ---- 早期：TTY 下强制英文 ----
      (lib.mkOrder 500 ''
        # Linux 虚拟控制台只有 256 个字形，渲染不了 CJK，
        # 所以在 tty 里把 locale 切成英文，避免满屏方块。
        if [[ "$TERM" == "linux" ]]; then
          export LANG=en_US.UTF-8
          export LC_ALL=en_US.UTF-8
        fi
      '')

      # ---- 中期：补全样式，必须在 compinit(570) 之后 ----
      (lib.mkOrder 1000 ''
        # 补全时忽略大小写
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        # 补全菜单用颜色区分文件类型
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        # 分组显示并带描述
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:descriptions' format '[%d]'

        # fzf-tab：用 eza 预览目录内容
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=always $realpath'
        zstyle ':fzf-tab:*' switch-group ',' '.'

        # fish 的 done 插件替代：命令跑超过 30 秒就发通知
        _cmd_start_time=0
        _notify_preexec() { _cmd_start_time=$SECONDS }
        _notify_precmd() {
          local elapsed=$(( SECONDS - _cmd_start_time ))
          if (( _cmd_start_time > 0 && elapsed > 30 )); then
            ${pkgs.libnotify}/bin/notify-send "命令完成" "耗时 ''${elapsed}s: $_last_cmd"
          fi
          _cmd_start_time=0
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook preexec _notify_preexec
        add-zsh-hook preexec '_last_cmd=$1'
        add-zsh-hook precmd _notify_precmd
      '')

      # ---- 函数：从 fish 翻译过来 ----
      (lib.mkOrder 1100 ''
        # Run OpenCode in rootful Podman
        opencode() {
          sudo podman run --rm -it \
            --runtime=runsc \
            --user "$(id -u):$(id -g)" \
            -e HOME=/home/opencode \
            -v "$HOME/Documents/opencode/workspace:/workspace:Z" \
            -v "$HOME/Documents/opencode/home:/home/opencode:Z" \
            -w /workspace \
            localhost/opencode-dev:local "$@"
        }
      '')
    ];
  };

  # ---- 各类集成，与 fish 版一一对应 ----
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  # xdg.configFile."starship.toml".source = ./starship.toml;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv.enableZshIntegration = true;
  programs.kitty.shellIntegration.enableZshIntegration = true;
  programs.yazi.enableZshIntegration = true;
  programs.zoxide.enableZshIntegration = true;
}
