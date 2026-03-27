local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Gruvbox Dark with pink accents
config.colors = {
	foreground = "#EBDBB2",
	background = "#282828",
	cursor_bg = "#D3869B",
	cursor_border = "#D3869B",
	cursor_fg = "#282828",
	selection_bg = "#504945",
	selection_fg = "#EBDBB2",
	ansi = { "#3C3836", "#CC241D", "#98971A", "#D79921", "#458588", "#B16286", "#689D6A", "#A89984" },
	brights = { "#928374", "#FB4934", "#B8BB26", "#FABD2F", "#83A598", "#D3869B", "#8EC07C", "#EBDBB2" },
	tab_bar = {
		background = "#282828",
		active_tab = {
			bg_color = "#D3869B",
			fg_color = "#282828",
		},
		inactive_tab = {
			bg_color = "#3C3836",
			fg_color = "#EBDBB2",
		},
		inactive_tab_hover = {
			bg_color = "#504945",
			fg_color = "#EBDBB2",
		},
		new_tab = {
			bg_color = "#3C3836",
			fg_color = "#EBDBB2",
		},
		new_tab_hover = {
			bg_color = "#504945",
			fg_color = "#EBDBB2",
		},
	},
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19
-- config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
config.default_cwd = wezterm.home_dir

config.keys = {
	{ key = "n", mods = "CMD", action = wezterm.action.SpawnCommandInNewWindow({ cwd = wezterm.home_dir }) },
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnCommandInNewTab({ cwd = wezterm.home_dir }) },
}

return config
