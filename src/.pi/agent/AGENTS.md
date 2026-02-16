## Pi Extensions

When creating or modifying pi extensions, always place them in:

`~/Code/dotfiles/src/.pi/agent/extensions/`

These are symlinked to `~/.pi/agent/extensions/` via the `dot` script. After adding a new extension, run `./dot` from `~/Code/dotfiles/` to create the symlink.

Similarly, pi keybindings live at `~/Code/dotfiles/src/.pi/agent/keybindings.json`.
