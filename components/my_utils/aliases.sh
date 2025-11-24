current_dir="$(cd "$(dirname "${(%):-%x}")" && pwd)"

mu() {
	"${current_dir}/commands.sh" "$@"
}

echo "Alias registered."

