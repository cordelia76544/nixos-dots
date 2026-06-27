{...}: {
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "/home/davyjones/Pictures/Screenshots";
        saveLastRegion = true;
        showHelp = false;
        saveAfterCopy = true;
        disabledTrayIcon = true;
      };
    };
  };
}
