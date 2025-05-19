# ⚙️ Neovim WSL Setup Guide

This guide outlines how to reproduce my Neovim environment from scratch using WSL, WezTerm, Nerd Font, and Starship.

---

## 1. Install Ubuntu via WSL

Open PowerShell as Administrator and run:
```powershell
wsl --install -d Ubuntu
```

## 2. Install WezTerm
Download and install the latest version from [wezterm.org/installation](https://wezterm.org/installation.html)

## 3. Configure WezTerm
Create ~/.wezterm.lua and paste the config:
```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = "OneHalfDark"

config.font = wezterm.font_with_fallback({
    "CaskaydiaCove Nerd Font",
    "Symbols Nerd Font Mono",
    "FiraCode Nerd Font",
})

config.font_size = 14.0
config.line_height = 1.1
config.cell_width = 1.0

config.window_decorations = 'RESIZE'
config.window_background_opacity = 1.0
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
    left = 4,
    right = 4,
    top = 2,
    bottom = 2,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  return {
    { Text = " " .. tab.active_pane.title .. " " },
  }
end)

config.scrollback_lines = 5000
config.default_cursor_style = 'BlinkingBar'
config.animation_fps = 60
config.max_fps = 60
config.audible_bell = "Disabled"

config.default_prog = { "wsl.exe" }

return config
```

## 4. Install a Nerd Font
Download and install CaskaydiaCove Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads) or [direct download](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip)

## 5. WSL Base Setup
Open WezTerm (with WSL) and run:
```bash
sudo apt update && sudo apt upgrade
sudo apt install -y curl git build-essential
```

## 6. Install Starship Prompt
```bash
curl -sS https://starship.rs/install.sh | sh
```
Then add this line to the end of the `~/.bashrc`:
```bash
eval "$(starship init bash)"
```
Apply it with the following command:
```bash
source ~/.bashrc
```

## 7. Install Neovim
TODO

##  8. Clone Neovim Config
```bash
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/...
```

## ✅ DONE!
Files can now be edited using `nvim` inside WezTerm.

# TODO:
- Possibly replace flat structure with returnable module.
- Tmux.
- Project templates.
- Simple scroll animation.
