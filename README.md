# ⚙️ Neovim WSL Setup Guide

This guide outlines how to reproduce my Neovim environment from scratch using WSL, WezTerm, Nerd Font, and Starship.

### 🛠 Prerequisites:
- Windows 11 (Windows 10 untested)
- AutoHotkey v2
- Bash as your WSL shell (Zsh/Fish users: adjust accordingly)

---

## 1. Install Ubuntu via WSL

Open PowerShell as Administrator and run:
```powershell
wsl --install -d Ubuntu
```

## 2. Install WezTerm + Nerd Font
- Download and install [wezterm.org/installation](https://wezterm.org/installation.html)
- Install CaskaydiaCove Nerd Font from [Nerd Fonts](https://www.nerdfonts.com/font-downloads), or use the [direct link](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip)

## 3. Configure WezTerm
Create ~/.wezterm.lua with:
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

## 4. WSL Base System + Tools
Launch WezTerm (using WSL) and run:

### Base packages:
```bash
sudo apt update && sudo apt upgrade
sudo apt install -y curl git build-essential unzip python3 python3-pip python3-venv lsd tmux
```

### Install tools via curl:
```bash
curl https://sh.rustup.rs -sSf | sh
curl -sS https://starship.rs/install.sh | sh
```

### Shell config:
```bash
echo 'alias ls="lsd"' >> ~/.bashrc
echo 'eval "$(starship init bash)"' >> ~/.bashrc
echo '[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"' >> ~/.bashrc
```

### Apply changes:
```bash
source ~/.bashrc
source ~/.cargo/env
```

## 5. Install Neovim (AppImage)
```bash
mkdir -p ~/.local/bin
cd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
[ -f nvim ] && mv nvim nvim.bak
mv nvim-linux-x86_64.appimage nvim
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 6. Clone Neovim Config
```bash
mkdir -p ~/.config
cd ~/.config
git clone https://github.com/Geferg/nvim-config
rm -rf ~/.config/nvim
ln -s ~/.config/nvim-config ~/.config/nvim
```

### Notes
- This step will clear out any old nvim config
- Replace Geferg/nvim-config with your own repo if forking

## ✅ DONE!
Files can now be edited using `nvim` inside WezTerm.

# TODO:
- Project templates
- Startup dashboard
- which-key inside neo-tree
- change set working directory/set project directory behavior
- fix cwd and project dir updates on netrw style buffers
- target correct buffer after building project
- auto-close build result if no errors
- make clean project mimic build style
- fix bug with unfocusing tree onto file with no file extension
- fix icon misalignment in neo-tree

# Plugin Wishlist
### Next
- nvim-autopairs

### Soon
- comment
- harpoon
- telescope

### Consider
- gitsigns
- diffview
- flash
- vim-repeat
- nvim-treesitter-context
- nvim-treesitter-textobjects

### Implemented
- hardtime
- lazy
- mason-lspconfig
- mason
- mini-animate
- neo-tree
- noice
- nvim-lspconfig
- nvim-notify
- nvim-treesitter
- render-markdown
- trouble
- twilight
- undotree
- vim-tmux-navigator
- which-key
---
- nui
- onedark
- plenary
- nvim-web-devicons
