#!/usr/bin/env sh

OPTION_KUBECONFIG="@tmux_kubenv_kubeconfig"

tmux_kubenv_precmd_hook() {
	# Update option with the current KUBECONFIG value
	if tmux info &> /dev/null; then
		tmux set-option -gp "$OPTION_KUBECONFIG" "$KUBECONFIG"
	fi
}

tmux_kubenv_precmd_hook_enable() {
	if [[ "${precmd_functions[@]}" =~ "tmux_kubenv_precmd_hook" ]]; then
		echo "Hook already enabled"
		return 0
	fi
	precmd_functions+=("tmux_kubenv_precmd_hook")
	echo "Hook enabled"
}

tmux_kubenv_precmd_hook_disable() {
	if [[ ! "${precmd_functions[@]}" =~ "tmux_kubenv_precmd_hook" ]]; then
		echo "Hook already disabled"
		return 0
	fi
	precmd_functions=("${precmd_functions[@]/tmux_kubenv_precmd_hook}")
	echo "Hook disabled"
}
