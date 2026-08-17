{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;

    settings = {
      background = "#000000";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 14;

      theme = "Material Design Colors"; # ghostty +list-themes 看可选
      background-opacity = 0.82;
      background-blur-radius = 20;

      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = false; # dwm 下不需要装饰

      cursor-style = "block";
      shell-integration = "zsh";
      confirm-close-surface = false;

      # 关掉内置标签页，交给 dwm 管窗口
      gtk-tabs-location = "hidden";
      gtk-single-instance = false;
    };
  };
}
