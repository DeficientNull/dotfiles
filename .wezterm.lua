-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- Changing the default wezterm font:
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 12
-- For example, changing the color scheme:
config.color_scheme = 'Tango (terminal.sexy)'
config.window_background_opacity = 0.80
config.enable_tab_bar = false

-- enable kitty graphics protocol
enable_kitty_graphics = true
-- and finally, return the configuration to wezterm
return config
