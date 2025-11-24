#!/usr/bin/env bash

# Toggles the workspace's background icon depending on whether it's active

monitor_id=$(aerospace list-workspaces --all --format "%{workspace} %{monitor-id}" | awk -v ws="$FOCUSED_WORKSPACE" '$1 == ws {print $2}')

echo "Debug aerospacer: { 1: $1, FOCUSED_WORKSPACE: $FOCUSED_WORKSPACE, NAME: $NAME, monitor_id: $monitor_id }"

if [[ "$1" = "$FOCUSED_WORKSPACE" ]]; then
	if [[ "$NAME" = "space.$monitor_id.$1" ]]; then
		sketchybar --set "$NAME" drawing=on
	else
		sketchybar --set "$NAME" drawing=off
	fi
fi

if [[ "$1" = "$FOCUSED_WORKSPACE" ]]; then
	sketchybar --set "$NAME" background.drawing=on
else
	sketchybar --set "$NAME" background.drawing=off
fi

