#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Rename Aerospace Workspace
# @raycast.mode compact 
#
# Optional parameters:
# @raycast.packageName Aerospace
# @raycast.currentDirectoryPath ../../my_utils
# @raycast.argument1 { "type": "text", "placeholder": "name", "optional": false }
# @raycast.argument2 { "type": "text", "placeholder": "id", "optional": true }

if [[ -z $2 ]]; then
	opt_arg=""
else
	opt_arg="-1 $2"
fi

./commands.sh rw ${opt_arg} $1

