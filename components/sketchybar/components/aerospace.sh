#!/usr/bin/env bash

PADDING=10
HEIGHT=23

all_workspace_ids=$(aerospace list-workspaces --all)

sketchybar --add event aerospace_workspace_change
for monitor_id in $(aerospace list-monitors --format "%{monitor-id}"); do
	visible_workspace_ids=$(aerospace list-workspaces --monitor "$monitor_id")

	# Draw monitor identifier
	sketchybar --add item monitor."$monitor_id" left \
		--set monitor."$monitor_id" \
		display="$monitor_id" \
		icon="$monitor_id" \
		icon.padding_left=$PADDING \
		icon.padding_right=$PADDING \
		icon.align=center \
		icon.width=50 \
		icon.y_offset=1 \
		icon.color=0xffffffff \
		label.drawing=off

	# Draw workspace identifiers
	for workspace_id in $all_workspace_ids; do
		is_workspace_visible=$(if [[ ${visible_workspace_ids[@]} =~ $workspace_id ]]; then echo 1; else echo 0; fi) 

		sketchybar --add item "space.$monitor_id.$workspace_id" left \
			--subscribe "space.$monitor_id.$workspace_id" aerospace_workspace_change \
			--set "space.$monitor_id.$workspace_id" \
			drawing=$(if [[ $is_workspace_visible == 1 ]]; then echo "on"; else echo "off"; fi) \
			display="$monitor_id" \
			icon="$workspace_id" \
			icon.padding_left=$PADDING \
			icon.padding_right=$PADDING \
			icon.align=left \
			icon.width=dynamic \
			icon.y_offset=1 \
			icon.color=0xffaaaaaa \
			label.drawing=off \
			label.string="" \
			label.color=0xffaaaaaa \
			label.padding_left=-3 \
			label.padding_right=$PADDING \
			background.color=0x22ffffff \
			background.corner_radius=5 \
			background.height=$HEIGHT \
			background.drawing=off \
			click_script="aerospace workspace $workspace_id" \
			script="~/.config/sketchybar/plugins/aerospacer.sh $workspace_id"
	done

	# Add bracket and include previous elements inside
	sketchybar --add bracket "bracket.monitor.$monitor_id" "monitor.$monitor_id" "/space\.$monitor_id\..*/" \
		--set bracket.monitor."$monitor_id" \
		display="$monitor_id" \
		background.drawing=off \
		background.border_color=0xffffffff \
		background.border_width=1 \
		background.height=25 \
		background.corner_radius=7
done

