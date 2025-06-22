#!/usr/bin/env sh

# ================================
# TMUX Options
# ================================

OPTION_KUBECONFIG="@tmux_kubenv_kubeconfig"

OPTION_COLOR_TITLE="@tmux_kubenv_color_title"
OPTION_COLOR_CONTEXT_FG="@tmux_kubenv_color_context_fg"
OPTION_COLOR_CONTEXT_BG="@tmux_kubenv_color_context_bg"
OPTION_COLOR_NAMESPACE_FG="@tmux_kubenv_color_namespace_fg"
OPTION_COLOR_NAMESPACE_BG="@tmux_kubenv_color_namespace_bg"

# ================================
# Utility functions
# ================================

tmux_kubenv_get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local value=$(tmux show-options -gpv "$option")

	if [ "$value" ]; then
		echo "$value"
	else
		echo "$default_value"
	fi
}

# ================================
# Settings
# ================================

TMUX_KUBENV_TITLE_KUBERNETES="Kubernetes"
TMUX_KUBENV_TITLE_KUBERNETES_SHORT="K8s"

TMUX_KUBENV_COLOR_KUBERNETES=$(tmux_kubenv_get_tmux_option $OPTION_COLOR_TITLE "#124F76")
TMUX_KUBENV_COLOR_CONTEXT_BG=$(tmux_kubenv_get_tmux_option $OPTION_COLOR_CONTEXT_BG "#124F76")
TMUX_KUBENV_COLOR_CONTEXT_FG=$(tmux_kubenv_get_tmux_option $OPTION_COLOR_CONTEXT_FG "#00DCEE")
TMUX_KUBENV_COLOR_NAMESPACE_BG=$(tmux_kubenv_get_tmux_option $OPTION_COLOR_NAMESPACE_BG "#124F76")
TMUX_KUBENV_COLOR_NAMESPACE_FG=$(tmux_kubenv_get_tmux_option $OPTION_COLOR_NAMESPACE_FG "#D69F00")

TMUX_KUBENV_PROMPT_NO_CONTENT="N/A"

# ================================
# Prompt functions
# ================================

tmux_kubenv_get_prompt_title(){
	local title_fg="fg=white"
	local title_bg="bg=$TMUX_KUBENV_COLOR_KUBERNETES"
	local title="$TMUX_KUBENV_TITLE_KUBERNETES ⎈"
	echo "#[$title_fg,$title_bg,nobold] $title"
}

tmux_kubenv_get_prompt_separator(){
	local separator=":"
	local separator_fg="fg=white"
	local separator_bg="bg=$TMUX_KUBENV_COLOR_KUBERNETES"
	echo "#[$separator_fg,$separator_bg]$separator"
}

tmux_kubenv_get_prompt_context(){
	local kubeconfig_context="$1"
	local context_fg="fg=$TMUX_KUBENV_COLOR_CONTEXT_FG"
	local context_bg="bg=$TMUX_KUBENV_COLOR_CONTEXT_BG"
	echo "#[$context_fg,$context_bg,bold]$kubeconfig_context"
}

tmux_kubenv_get_prompt_namespace(){
	local kubeconfig_namespace="$1"
	local namespace_fg="fg=$TMUX_KUBENV_COLOR_NAMESPACE_FG"
	local namespace_bg="bg=$TMUX_KUBENV_COLOR_NAMESPACE_BG"
	echo "#[$namespace_fg,$namespace_bg,bold]$kubeconfig_namespace"
}

tmux_kubenv_get_prompt_bracker_left(){
	local bracker_left_fg="fg=white"
	local bracker_left_bg="bg=$TMUX_KUBENV_COLOR_KUBERNETES"
	echo "#[$bracker_left_fg,$bracker_left_bg]["
}

tmux_kubenv_get_prompt_bracker_right(){
	local bracker_right_fg="fg=white"
	local bracker_right_bg="bg=$TMUX_KUBENV_COLOR_KUBERNETES"
	echo "#[$bracker_right_fg,$bracker_right_bg]]"
}

tmux_kubenv_get_prompt(){
	local kubeconfig_context="$1"
	local kubeconfig_namespace="$2"

	local title=$(tmux_kubenv_get_prompt_title)
	local separator=$(tmux_kubenv_get_prompt_separator)

	local context=$(tmux_kubenv_get_prompt_context "$kubeconfig_context")
	local namespace=$(tmux_kubenv_get_prompt_namespace "$kubeconfig_namespace")

	local bracker_left=$(tmux_kubenv_get_prompt_bracker_left)
	local bracker_right=$(tmux_kubenv_get_prompt_bracker_right)

	echo "$title $bracker_left$context$separator$namespace$bracker_right"
}

# ================================
# Main
# ================================

tmux_kubenv_get_kubeconfig_context() {
	local kubeconfig="$1"
	local context=$(kubectl --kubeconfig="$kubeconfig" config current-context 2>/dev/null)
	if [ -z "$context" ]; then
		echo $TMUX_KUBENV_PROMPT_NO_CONTENT
		return 1
	fi

	echo "$context"
}

tmux_kubenv_get_kubeconfig_namespace() {
	local kubeconfig="$1"
	local context=$(tmux_kubenv_get_kubeconfig_context "$kubeconfig")
	if [[ "$context" == "$TMUX_KUBENV_PROMPT_NO_CONTENT" ]]; then
		echo $TMUX_KUBENV_PROMPT_NO_CONTENT
		return 1
	fi

	local namespace=$(kubectl --kubeconfig="$kubeconfig" config view -o jsonpath='{..contexts[?(@.name == "'$context'")].context.namespace}')
	if [ -z "$namespace" ]; then
		echo $TMUX_KUBENV_PROMPT_NO_CONTENT
		return 1
	fi

	echo "$namespace"
}

tmux_kubenv() {
	local kubeconfig=$(tmux_kubenv_get_tmux_option "$OPTION_KUBECONFIG" "")
	if [ -z "$kubeconfig" ]; then
		echo $(tmux_kubenv_get_prompt $TMUX_KUBENV_PROMPT_NO_CONTENT $TMUX_KUBENV_PROMPT_NO_CONTENT)
		return 0
	fi

	local kubeconfig_context=$(tmux_kubenv_get_kubeconfig_context "$kubeconfig")
	local kubeconfig_namespace=$(tmux_kubenv_get_kubeconfig_namespace "$kubeconfig")

	echo $(tmux_kubenv_get_prompt $kubeconfig_context $kubeconfig_namespace)
}

tmux_kubenv $@
