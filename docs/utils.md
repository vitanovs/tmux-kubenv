# Utilities

Helper utilities supporting the plugin functionality.

## `tmux_kubenv_precmd_hook` [hook](https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions) function

A [ZSH](https://www.zsh.org) `precmd` [hook](https://zsh.sourceforge.io/Doc/Release/Functions.html#Hook-Functions) function that automatically updates the plugin context based on the current `KUBECONFIG` in use.
To allow configurable _enable_/_disable_ capability to the hook, two additional functions are provided:

- `tmux_kubenv_precmd_hook_enable` - __adds__ the `hook` to the `precmd_functions` list
- `tmux_kubenv_precmd_hook_disable` - __removes__ the `hook` from the `precmd_functions` list
