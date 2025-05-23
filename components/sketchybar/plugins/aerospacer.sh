#!/usr/bin/env bash

# Toggles the workspace's background icon depending on whether it's active

echo "called with $1"
echo "$FOCUSED_WORKSPACE"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
	sketchybar --set $NAME background.drawing=on
else
	sketchybar --set $NAME background.drawing=off
fi

