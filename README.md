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

## 3. Install a Nerd Font
Download and install CaskaydiaCove Nerd Font from [Nerd Fonts](https://www.nerdfonts.com/font-downloads), or use the [direct link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip)

## 4. Configure WezTerm
Create ~/.wezterm.lua and paste in the following configuration:
```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = "OneHalfDark"

config.font = wezterm.font_with_fallback({
    "CaskaydiaCove Nerd Font",
    "FiraCode Nerd Font",
    "Symbols Nerd Font Mono",
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
```bash
mkdir -p ~/.local/bin
cd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
mv nvim-linux-x86_64.appimage nvim

if ! grep -Fxq 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi
```

##  8. Clone Neovim Config
```bash
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/Geferg/nvim-config
rm -rf ~/.config/nvim
ln -s ~/.config/nvim-config ~/.config/nvim
```

Small note: Replace Geferg/nvim-config with your own repo if forking.

## ✅ DONE!
Files can now be edited using `nvim` inside WezTerm.

# TODO:
- Possibly replace flat structure with returnable module.
- Tmux.
- Project templates.
- Simple scroll animation.
- Set top level dir in sidebar tree.
- Add hardtime disabled by default.
