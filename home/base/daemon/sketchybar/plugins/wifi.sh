#!/bin/bash

# Wi-Fi情報を取得
SSID="$(networksetup -listpreferredwirelessnetworks en0 | sed -n '2 p' | tr -d '\t')"

if [ "$SSID" = "" ]; then
  # 未接続の場合
  sketchybar --set $NAME label="Disc." icon= icon.color=0xff5e6375
else
  # 接続中の場合 (SSIDを表示)
  # 長すぎる場合はカットしてもいいが、一旦そのまま表示
  sketchybar --set $NAME label="$SSID" icon= icon.color=0xffffffff
fi
