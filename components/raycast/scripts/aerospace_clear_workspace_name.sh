#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clear Aerospace Workspace Name
# @raycast.mode compact
#
# Optional parameters:
# @raycast.packageName Aerospace
# @raycast.currentDirectoryPath ../../my_utils
# @raycast.argument1 { "type": "text", "placeholder": "id", "optional": true }

./commands.sh cw -i $1

