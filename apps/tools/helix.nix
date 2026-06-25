{...}: {
  programs.helix = {
    enable = true;
    defaultEditor = false;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
    };
  };
}
