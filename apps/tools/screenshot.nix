{pkgs, ...}: let
  screenshot-area = pkgs.writeShellScriptBin "screenshot-area" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | \
      ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  screenshot-ocr-area = pkgs.writeShellScriptBin "screenshot-ocr-area" ''
    #!/usr/bin/env bash
    set -euo pipefail

    tmp="$(mktemp --suffix=.png)"
    trap 'rm -f "$tmp"' EXIT

    # 选区截图到临时文件
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$tmp"

    # OCR
    text="$(${pkgs.tesseract}/bin/tesseract "$tmp" stdout -l chi_tra+eng 2>/dev/null || true)"

    # 去掉前后空白
    text="$(printf '%s' "$text" | ${pkgs.gnused}/bin/sed -e 's/^[[:space:]]*//' -e :a -e '/^\n*$/{$d;N;ba' -e '}' )"

    if [ -z "$text" ]; then
      ${pkgs.libnotify}/bin/notify-send "OCR" "no text found"
      exit 1
    fi

    printf '%s' "$text" | ${pkgs.wl-clipboard}/bin/wl-copy --type text/plain
    ${pkgs.libnotify}/bin/notify-send "OCR completed" "copied"
  '';
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    tesseract
    libnotify
    gnused

    screenshot-area
    screenshot-ocr-area
  ];
}
