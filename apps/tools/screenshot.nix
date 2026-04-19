{pkgs, ...}: let
  screenshot-area = pkgs.writeShellScriptBin "screenshot-area" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | \
      ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  screenshot-ocr-area = pkgs.writeShellScriptBin "screenshot-ocr-area" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    UMI_URL="''${UMI_URL:-http://127.0.0.1:1224/api/ocr}"

    notify() {
      ${pkgs.libnotify}/bin/notify-send "$@"
    }

    if ! region="$(${pkgs.slurp}/bin/slurp)"; then
      notify "Umi OCR" "Selection cancelled."
      exit 1
    fi

    if ! img_b64="$(
      ${pkgs.grim}/bin/grim -g "$region" -t jpeg -q 70 - \
        | ${pkgs.coreutils}/bin/base64 -w 0
    )"; then
      notify "Umi OCR" "Failed to capture screenshot."
      exit 1
    fi

    if ! result="$(
      ${pkgs.jq}/bin/jq -n \
        --arg base64 "$img_b64" \
        '{
          base64: $base64,
          options: {
            "ocr.language": "models/config_chinese.txt",
            "ocr.cls": true,
            "data.format": "text"
          }
        }' \
      | ${pkgs.curl}/bin/curl -fsS \
          -H 'Content-Type: application/json' \
          -d @- \
          "$UMI_URL" \
      | ${pkgs.jq}/bin/jq -r '.data'
    )"; then
      notify "Umi OCR" "OCR request failed."
      exit 1
    fi

    if [ -z "$result" ] || [ "$result" = "null" ]; then
      notify "Umi OCR" "No text recognized."
      exit 1
    fi

    printf '%s' "$result" | ${pkgs.wl-clipboard}/bin/wl-copy
    printf '%s\n' "$result"

    notify "Umi OCR" "OCR text copied to clipboard."
  '';
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    libnotify
    gnused

    screenshot-area
    screenshot-ocr-area
  ];
}
