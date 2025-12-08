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
Create ~/.wezterm.lua on the windows system with:
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

config.default_prog = { "wsl.exe", "--cd", "~" }

return config
```

If you are unsure how to create this file, do:
1. `nano ~/.wezterm.lua`
2. paste in the code above
3. save with ctrl + o and press enter
4. close with ctrl + x

For Linux systems I am using this (zsh!):
```lua
local wezterm = require 'wezterm'
local mux = wezterm.mux
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

--config.window_decorations = 'RESIZE'
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

wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

config.scrollback_lines = 5000
config.default_cursor_style = 'BlinkingBar'
config.animation_fps = 60
config.max_fps = 60
config.audible_bell = "Disabled"

config.default_prog = { "/usr/bin/zsh", "-l" }

config.keys = {
    {
        key = "w",
        mods = "CTRL",
        action = wezterm.action.CloseCurrentTab { confirm = false },
    },
    {
        key = "t",
        mods = "CTRL",
        action = wezterm.action.SpawnTab "DefaultDomain",
    },
    { key = "1", mods = "CTRL", action = wezterm.action.ActivateTab(0) },
    { key = "2", mods = "CTRL", action = wezterm.action.ActivateTab(1) },
    { key = "3", mods = "CTRL", action = wezterm.action.ActivateTab(2) },
    { key = "4", mods = "CTRL", action = wezterm.action.ActivateTab(3) },
    { key = "5", mods = "CTRL", action = wezterm.action.ActivateTab(4) },
    { key = "6", mods = "CTRL", action = wezterm.action.ActivateTab(5) },
    { key = "7", mods = "CTRL", action = wezterm.action.ActivateTab(6) },
    { key = "8", mods = "CTRL", action = wezterm.action.ActivateTab(7) },
    { key = "9", mods = "CTRL", action = wezterm.action.ActivateTab(8) },
}

wezterm.on('user-var-changed', function(window, pane, name, value)
    local overrides = window:get_config_overrides() or {}
    if name == "ZEN_MODE" then
        local incremental = value:find("+")
        local number_value = tonumber(value)
        if incremental ~= nil then
            while (number_value > 0) do
                window:perform_action(wezterm.action.IncreaseFontSize, pane)
                number_value = number_value - 1
            end
            overrides.enable_tab_bar = false
        elseif number_value < 0 then
            window:perform_action(wezterm.action.ResetFontSize, pane)
            overrides.font_size = nil
            overrides.enable_tab_bar = true
        else
            overrides.font_size = number_value
            overrides.enable_tab_bar = false
        end
    end
    window:set_config_overrides(overrides)
end)

return config
```

## 4. WSL Base System + Tools
Launch WezTerm (using WSL) and run:

### Base packages:
```bash
sudo apt update && sudo apt upgrade
sudo apt install -y curl git build-essential unzip python3 python3-pip python3-venv lsd tmux pkg-config libssl-dev npm
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
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
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
- This step will clear out any old nvim config, make sure you are inside the new WSL
- Replace Geferg/nvim-config with your own repo if forking

## 7. Extras
```bash
cargo install cargo-generate
```

## ✅ DONE!
Files can now be edited using `nvim` inside WezTerm.

# File structure
## Root
This is where the main config entry point (`init.lua`) lives, along with this README, Git-related files, and the `lazy-lock.json` which stores exact plugin versions used by Lazy.

## lua/
This folder contains all Lua code used in the config. It's organized into three main subfolders, each with a clear purpose:

### Config/
These files are directly referenced from `init.lua`.
- `options.lua`: Basic Neovim settings.
- `lazy.lua`: Bootstraps the plugin manager and loads all plugin definitions from the `plugins/` folder.
- `lsp.lua`: Sets up the built-in LSP client. No need for something like `mason-lspconfig`.
- `autocmds.lua`: Where autocommands go. (Mind-blowing.)

### Features
This folder contains helper functions or logic that are too long or general-purpose to belong in a single plugin file. They're used across different parts of the config.

### Plugins
Each plugin gets its own file for setup and configuration. This makes it easy to locate or modify a specific plugin. You can also "disable" a plugin by renaming its file to end with `.bak`.

## Misc
A catch-all for anything that is necessary but does not belong anywhere else. It might get further organized.. or not.

# TODO:
- Project templates
- Startup dashboard
- change set working directory/set project directory behavior
- fix cwd and project dir updates on netrw style buffers
- target correct buffer after building project
- auto-close build result if no errors
- make clean project mimic build style
- fix bug with unfocusing tree onto file with no file extension
- fix icon misalignment in neo-tree
- track down reason for sometimes getting extremely slow pastes
- fix bug where LSP times out on auto-formatting rouge brackets(?)
- add cross-platform hotkey setup

# Plugin Wishlist
### Next

### Soon
- zen-mode

### Consider
- flash
- vim-repeat
- nvim-treesitter-context
- nvim-treesitter-textobjects
- nvim-cokeline
- hologram
- presence
- nvim-surround
