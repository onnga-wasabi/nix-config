#!/bin/bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    # --animate tanh 10 を追加すると、10ステップかけてヌルっと変化する
    sketchybar --animate tanh 10 --set $NAME \
        background.drawing=on \
        background.color=0xff493863 \
        label.color=0xffffffff \
        label.font="SF Pro:Bold:15.0"
else
    sketchybar --animate tanh 10 --set $NAME \
        background.drawing=off \
        label.color=0xff9399b2 \
        label.font="SF Pro:Bold:14.0"
fi
