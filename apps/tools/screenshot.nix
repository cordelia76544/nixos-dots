{pkgs, ...}: let
  screenshot-ocr-area = pkgs.writeShellScriptBin "screenshot-ocr-area" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    UMI_URL="''${UMI_URL:-http://127.0.0.1:1224/api/ocr}"

    notify() {
      ${pkgs.libnotify}/bin/notify-send -t 4000 "$@"
    }

    # 使用临时文件避免二进制数据通过变量传递损坏
    tmp_img=$(${pkgs.coreutils}/bin/mktemp /tmp/ocr-XXXXXX.png)
    trap 'rm -f "$tmp_img"' EXIT

    # 截图，用户取消（退出码非0）则静默退出
    if ! ${pkgs.maim}/bin/maim -s -u "$tmp_img" 2>/dev/null; then
      exit 0
    fi

    # 确认文件非空
    if [ ! -s "$tmp_img" ]; then
      notify "Umi OCR" "截图文件为空"
      exit 1
    fi

    # 转换为 base64（直接从文件读取，避免管道中二进制损坏）
    img_b64=$(
      ${pkgs.imagemagick}/bin/convert "$tmp_img" -format jpeg -quality 70 jpeg:- \
        | ${pkgs.coreutils}/bin/base64 -w 0
    )

    if [ -z "$img_b64" ]; then
      notify "Umi OCR" "图片转换失败"
      exit 1
    fi

    # 构造请求并调用 Umi-OCR
    response=$(
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
          --max-time 15 \
          --retry 2 \
          --retry-delay 1 \
          -H 'Content-Type: application/json' \
          -d @- \
          "$UMI_URL" 2>&1
    ) || {
      notify "Umi OCR" "无法连接服务，请确认 Umi-OCR 已启动\n地址: $UMI_URL"
      exit 1
    }

    # 检查 HTTP 响应是否为合法 JSON
    if ! echo "$response" | ${pkgs.jq}/bin/jq empty 2>/dev/null; then
      notify "Umi OCR" "服务返回非法响应:\n$response"
      exit 1
    fi

    # 检查业务状态码（Umi-OCR 成功为 100）
    code=$(echo "$response" | ${pkgs.jq}/bin/jq -r '.code // empty')
    if [ "$code" != "100" ]; then
      errmsg=$(echo "$response" | ${pkgs.jq}/bin/jq -r '.data // "未知错误"')
      notify "Umi OCR" "OCR 失败 (code=$code):\n$errmsg"
      exit 1
    fi

    result=$(echo "$response" | ${pkgs.jq}/bin/jq -r '.data // empty')

    if [ -z "$result" ]; then
      notify "Umi OCR" "未识别到任何文字"
      exit 1
    fi

    # 写入剪贴板
    printf '%s' "$result" | ${pkgs.xclip}/bin/xclip -selection clipboard

    notify "Umi OCR" "✓ 已复制到剪贴板"
  '';
in {
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
