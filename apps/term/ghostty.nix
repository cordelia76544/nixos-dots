{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    systemd.enable = true;

    settings = {
      background = "#000000";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 14;

      theme = "Material Design Colors"; # ghostty +list-themes 看可选
      background-opacity = 0.76;
      background-blur-radius = 20;

      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = false;

      cursor-style = "block";
      shell-integration = "zsh";
      confirm-close-surface = false;

      gtk-tabs-location = "hidden";
      gtk-single-instance = false;
    };
  };
}
