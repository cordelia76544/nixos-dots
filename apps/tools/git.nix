{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings.user.name = "davyjones";
    settings.user.email = "cordeliahoward@outlook.com";
  };

  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gui = {
        showFileTree = true;
        nerdFontsVersion = "3";
        showRandomTip = false;
      };
      git.paging.pager = "delta --dark --paging=never";
    };
  };

  home.packages = with pkgs; [delta];
}
