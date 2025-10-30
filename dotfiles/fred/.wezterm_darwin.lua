-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- This will hold the configuration.
-- local config = wezterm.config_builder()
local mux = wezterm.mux

-- This is where you actually apply your config choices

config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 12
config.enable_wayland = false
config.term = "wezterm"
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.95

local act = wezterm.action
config.keys = {
	{ mods = "OPT", key = "LeftArrow", action = act.SendKey({ mods = "ALT", key = "b" }) },
	{ mods = "OPT", key = "RightArrow", action = act.SendKey({ mods = "ALT", key = "f" }) },
	{ mods = "CMD", key = "LeftArrow", action = act.SendKey({ mods = "CTRL", key = "a" }) },
	{ mods = "CMD", key = "RightArrow", action = act.SendKey({ mods = "CTRL", key = "e" }) },
	{ mods = "CMD", key = "Backspace", action = act.SendKey({ mods = "CTRL", key = "u" }) },
	{ mods = "CMD|OPT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
	{ mods = "CMD|OPT", key = "RightArrow", action = act.ActivateTabRelative(1) },
	{ mods = "CMD|SHIFT", key = "LeftArrow", action = act.ActivateTabRelative(-1) },
	{ mods = "CMD|SHIFT", key = "RightArrow", action = act.ActivateTabRelative(1) },
}

return config

-- 1512x854
