{...}: let
  browser = "brave-browser.desktop";

  wpsWriter = "wps-office-wps.desktop";
  wpsSheet = "wps-office-et.desktop";
  wpsPresentation = "wps-office-wpp.desktop";

  imageViewer = "qimgv.desktop";
in {
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Browser
      "text/html" = browser;
      "application/xhtml+xml" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;

      # WPS Writer: doc/docx/dot/dotx/rtf/odt
      "application/msword" = wpsWriter;
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = wpsWriter;
      "application/vnd.openxmlformats-officedocument.wordprocessingml.template" = wpsWriter;
      "application/vnd.ms-word.document.macroEnabled.12" = wpsWriter;
      "application/vnd.ms-word.template.macroEnabled.12" = wpsWriter;
      "application/rtf" = wpsWriter;
      "text/rtf" = wpsWriter;
      "application/vnd.oasis.opendocument.text" = wpsWriter;

      # WPS Spreadsheets: xls/xlsx/xlt/xltx/xlsm/csv/ods
      "application/vnd.ms-excel" = wpsSheet;
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = wpsSheet;
      "application/vnd.openxmlformats-officedocument.spreadsheetml.template" = wpsSheet;
      "application/vnd.ms-excel.sheet.macroEnabled.12" = wpsSheet;
      "application/vnd.ms-excel.template.macroEnabled.12" = wpsSheet;
      "text/csv" = wpsSheet;
      "application/csv" = wpsSheet;
      "application/vnd.oasis.opendocument.spreadsheet" = wpsSheet;

      # WPS Presentation: ppt/pptx/pps/ppsx/pot/potx/odp
      "application/vnd.ms-powerpoint" = wpsPresentation;
      "application/vnd.openxmlformats-officedocument.presentationml.presentation" = wpsPresentation;
      "application/vnd.openxmlformats-officedocument.presentationml.template" = wpsPresentation;
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow" = wpsPresentation;
      "application/vnd.ms-powerpoint.presentation.macroEnabled.12" = wpsPresentation;
      "application/vnd.ms-powerpoint.template.macroEnabled.12" = wpsPresentation;
      "application/vnd.ms-powerpoint.slideshow.macroEnabled.12" = wpsPresentation;
      "application/vnd.oasis.opendocument.presentation" = wpsPresentation;

      # PDf
      "application/pdf" = ["org.pwmt.zathura.desktop"];

      # file
      "inode/directory" = ["yazi-kitty.desktop"];

      # 常见图片格式
      "image/jpeg" = imageViewer;
      "image/png" = imageViewer;
      "image/gif" = imageViewer;
      "image/webp" = imageViewer;
      "image/bmp" = imageViewer;
      "image/tiff" = imageViewer;
      "image/svg+xml" = imageViewer;

      # 现代图片格式
      "image/avif" = imageViewer;
      "image/heic" = imageViewer;
      "image/heif" = imageViewer;
      "image/jxl" = imageViewer;

      # 其他常见格式
      "image/x-icon" = imageViewer;
      "image/vnd.microsoft.icon" = imageViewer;
      "image/x-tga" = imageViewer;
      "image/x-xcf" = imageViewer;
      "image/x-portable-anymap" = imageViewer;
      "image/x-portable-bitmap" = imageViewer;
      "image/x-portable-graymap" = imageViewer;
      "image/x-portable-pixmap" = imageViewer;
    };
  };
}
