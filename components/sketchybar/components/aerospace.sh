#!/usr/bin/env bash

PADDING=10
HEIGHT=23

sketchybar --add event aerospace_workspace_change
for sid in $(aerospace list-workspaces --all); do
	sketchybar --add item space."$sid" left \
		--subscribe "space.$sid" aerospace_workspace_change \
		--set space."$sid" \
		icon="$sid" \
		icon.padding_left=$PADDING \
		icon.padding_right=$PADDING \
		icon.align=center \
		icon.width=50 \
		icon.y_offset=1 \
		label.drawing=off \
		background.color=0x22ffffff \
		background.corner_radius=5 \
		background.height=$HEIGHT \
		background.drawing=off \
		click_script="aerospace workspace $sid" \
		script="~/.config/sketchybar/plugins/aerospacer.sh $sid"
done

