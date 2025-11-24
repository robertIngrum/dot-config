#!/bin/bash

renameWorkspace() {
	local OPTIND
	local workspace_id

	while getopts ":i:" opt; do
		case "$opt" in
			i) workspace_id=$OPTARG ;;
			\?) ;;
		esac
	done
	
	shift $(($OPTIND - 1))

	local new_name="$1"

	if [[ -z "$new_name" ]]; then
		echo "Must specify new workspace name."
		return
	fi

	workspace_id=${workspace_id:=$(aerospace list-workspaces --focused)}

	for monitor_id in $(aerospace list-monitors --format "%{monitor-id}"); do
		sketchybar --set "space.${monitor_id}.${workspace_id}" label.string="$new_name" label.drawing=on
	done

	echo "Workspace renamed to $new_name"
}

clearWorkspaceName() {
	local OPTIND
	local workspace_id

	while getopts ":i:" opt; do
		case "$opt" in
			i) workspace_id=$OPTARG ;;
			\?) ;;
		esac
	done
	
	shift $(($OPTIND - 1))

	workspace_id=${workspace_id:=$(aerospace list-workspaces --focused)}

	for monitor_id in $(aerospace list-monitors --format "%{monitor-id}"); do
		sketchybar --set "space.${monitor_id}.${workspace_id}" label.string="" label.drawing=off
	done

	echo "Workspace name cleared"
}

usage() {
	echo "Look at my_utils/commands.sh, should be \`mu [command_name] [...rest]\`"
}

main() {
	command=$1
	shift

	case $command in
		rw | renameworkspace)
			renameWorkspace "$@"
			exit 0
			;;
		cw | clearworkspace)
			clearWorkspaceName "$@"
			exit 0
			;;
		h | help | *)
			usage
			exit 0
			;;
	esac
}

main "$@"
