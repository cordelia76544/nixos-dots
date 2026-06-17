{lib, ...}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    enableGitIntegration = true;

    # 1. 字体配置
    #font = {
    #  name = "Google Sans Code";
    # size = 15.0;
    #};

    settings = {
      background = lib.mkForce "#000000";
      # Font variants
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      # Window Configuration
      window_padding_width = 12;
      #background_opacity = "1.0";
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
  };
}
