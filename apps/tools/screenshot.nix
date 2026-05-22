{pkgs, ...}: let
  screenshot-ocr-area = pkgs.writeShellScriptBin "screenshot-ocr-area" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    # 如果你的 Umi-OCR 端口不同，可以在这里修改
    UMI_URL="''${UMI_URL:-http://127.0.0.1:1224/api/ocr}"

    notify() {
      ${pkgs.libnotify}/bin/notify-send "$@"
    }

    # 使用 maim 进行 X11 选区，如果不成功（比如按 Esc 取消）则退出
    if ! img_stream=$(${pkgs.maim}/bin/maim -s -u); then
      notify "Umi OCR" "选区已取消"
      exit 0
    fi

    # 将图片流压缩为 jpeg 并转为 base64
    if ! img_b64="$(
      echo "$img_stream" \
        | ${pkgs.imagemagick}/bin/convert - -format jpeg -quality 70 - \
        | ${pkgs.coreutils}/bin/base64 -w 0
    )"; then
      notify "Umi OCR" "截图转换失败"
      exit 1
    fi

    # 请求 Umi-OCR 接口
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
          --retry 3 \
          --retry-delay 2 \
          -H 'Content-Type: application/json' \
          -d @- \
          "$UMI_URL" \
      | ${pkgs.jq}/bin/jq -r '.data'
    )"; then
      notify "Umi OCR" "OCR 请求失败，请检查服务是否开启"
      exit 1
    fi

    if [ -z "$result" ] || [ "$result" = "null" ]; then
      notify "Umi OCR" "未识别到任何文字"
      exit 1
    fi

    # 复制到 X11 剪贴板 (CopyQ 会自动捕获)
    printf '%s' "$result" | ${pkgs.xclip}/bin/xclip -selection clipboard

    notify "Umi OCR" "文字已成功复制到剪贴板"
  '';
in {
  # 2. 安装所有需要的辅助工具和刚才定义的脚本
  home.packages = with pkgs; [
    screenshot-ocr-area
    maim
    imagemagick
    xclip
    jq
    libnotify
  ];

  # 3. 启用并配置 Flameshot 服务
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
