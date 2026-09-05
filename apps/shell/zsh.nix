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
      (lib.mkOrder 500 ''
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
      (
        lib.mkOrder 1200 ''
          k8sbox() {
              sudo podman run --rm -it \
                --name k8s-toolbox-$$ \
                --hostname k8s-toolbox --uts=private \
                --net=host \
                -v "$HOME/.kube:/home/davyjones/.kube:ro,Z" \
                -v "$HOME/Documents/workspace/k8s:/home/davyjones/workspace:Z" \
                -w /home/davyjones/workspace \
                ghcr.io/cordelia76544/k8s-toolbox:latest "$@"
            }
        ''
      )
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
