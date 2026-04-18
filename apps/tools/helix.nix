{...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "everforest_light";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
    };
  };
}
