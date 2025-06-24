# tmux-kubenv

A [TMUX](https://github.com/tmux/tmux) plugin indicating the current [Kubernetes](https://kubernetes.io) context in use.

:white_check_mark: Per-`pane` context with automatic updates based on configuration _switches_ and _changes_.

![demo](https://github.com/vitanovs/tmux-kubenv/blob/main/docs/media/tmux_kubenv_demo.gif)

## Installation

Using the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) to manage the configuration:

- _add_ the _plugin_ to your `~/.tmux.conf`:

  ```sh
  set -g @plugin 'vitanovs/tmux-kubenv'
  ```

- _install_ with `<prefix> + I`

Once installed, instrument:

- `.tmux.conf` with `kubenv.tmux` utility to display the current context in your status line:

  ```sh
  set -g status-left "#(/bin/sh ~/.tmux/plugins/tmux-kubenv/kubenv.tmux)"
  ```

- `.zshrc` to _enable_ the __automatic__ context _updates_:

  ```sh
  source ~/.tmux/plugins/tmux-kubenv/scripts/hook_zsh.sh
  tmux_kubenv_precmd_hook_enable > /dev/null
  ```

## Configuration

The plugin supports the following `global` configuration options:

| Title                             | Description                                       |  Default     |
| :-------------------------------- | :------------------------------------------------ | :----------: |
| `@tmux_kubenv_title`              | The _plugin_ title displayed in the status line   | `Kubernetes` |
| `@tmux_kubenv_color_title`        | The _color_ of the _plugin_ title                 | `#124F76"`   |
| `@tmux_kubenv_color_context_fg`   | The _foreground color_ of the _context_ section   | `#124F76"`   |
| `@tmux_kubenv_color_context_bg`   | The _background color_ of the _context_ section   | `#00DCEE`    |
| `@tmux_kubenv_color_namespace_fg` | The _foreground color_ of the _namespace_ section | `#124F76`    |
| `@tmux_kubenv_color_namespace_bg` | The _background color_ of the _namespace_ section | `#D69F00`    |
