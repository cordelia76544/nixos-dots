{...}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;

    # 1. 字体配置
    font = {
      name = "Google Sans Code";
      size = 15.0;
    };

    # 2. 一般设置 (对应 conf 中的 key value)
    settings = {
      # Font variants
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Window Configuration
      window_padding_width = 12;
      background_opacity = "1.0";
      background_blur = 32;
      hide_window_decorations = "yes";

      # Cursor Configuration
      cursor_shape = "block";
      cursor_blink_interval = 1;

      # Scrollback
      scrollback_lines = 3000;

      # Terminal features
      copy_on_select = "yes";
      strip_trailing_spaces = "smart";

      # Tab configuration
      tab_bar_style = "powerline";
      tab_bar_align = "left";

      # Shell integration
      shell_integration = "enabled";
    };

    # 3. 按键绑定
    keybindings = {
      "ctrl+shift+n" = "new_window";
      "ctrl+t" = "new_tab";
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+0" = "change_font_size all 0";
    };

    # 4. 引用外部文件
    extraConfig = ''
      include dank-tabs.conf
      include dank-theme.conf
    '';
  };

  # 5. 确保 dank-*.conf 文件被链接到 ~/.config/kitty/ 下
  # 假设这两个文件就在当前 kitty.nix 的同级目录下
  xdg.configFile = {
    "kitty/dank-tabs.conf".source = ./dank-tabs.conf;
    "kitty/dank-theme.conf".source = ./dank-theme.conf;
  };
}
