-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local callback = wezterm.action_callback

-- This table will hold the configuration.
local config = {}

local PANE_SIZE_STEP = 5
local RECORDING_FONT_SIZE = 20

local LINUX_FONT_SIZE = 10.3
local LINUX_WINDOW_BACKGROUND_OPACITY = 0.85
local LINUX_WINDOW_BACKGROUND_BLUR = 0

local MACOS_FONT_SIZE = 11.0
local MACOS_WINDOW_BACKGROUND_OPACITY = 0.65
local MACOS_WINDOW_BACKGROUND_BLUR = 30

local font_size = MACOS_FONT_SIZE
local window_background_opacity = MACOS_WINDOW_BACKGROUND_OPACITY
local window_background_blur = MACOS_WINDOW_BACKGROUND_BLUR

local function is_linux()
	return io.popen("uname -s"):read() == "Linux"
end

if is_linux() then
	font_size = LINUX_FONT_SIZE
	window_background_opacity = LINUX_WINDOW_BACKGROUND_OPACITY
	window_background_blur = LINUX_WINDOW_BACKGROUND_BLUR
else
	font_size = MACOS_FONT_SIZE
	window_background_opacity = MACOS_WINDOW_BACKGROUND_OPACITY
	window_background_blur = MACOS_WINDOW_BACKGROUND_BLUR
end

local function set_transparency(activate, window)
	local config_overrides = window:effective_config()

	if activate then
		if is_linux() then
			config_overrides.window_background_opacity = LINUX_WINDOW_BACKGROUND_OPACITY
			config_overrides.macos_window_background_blur = 0
		else
			config_overrides.window_background_opacity = MACOS_WINDOW_BACKGROUND_OPACITY
			config_overrides.macos_window_background_blur = MACOS_WINDOW_BACKGROUND_BLUR
		end
	else
		config_overrides.window_background_opacity = 1
		config_overrides.macos_window_background_blur = 0
	end

	window:set_config_overrides(config_overrides)
	return config_overrides
end

local function toggle_transparency(window)
	local is_transparent = window:effective_config().window_background_opacity < 1
	set_transparency(not is_transparent, window)
end

local function toggle_recording_mode(window)
	local is_recording_video = window:effective_config().font_size == RECORDING_FONT_SIZE

	local config_overrides = set_transparency(is_recording_video, window)

	if is_recording_video then
		config_overrides.font_size = font_size
	else
		config_overrides.font_size = RECORDING_FONT_SIZE
	end

	window:set_config_overrides(config_overrides)
	is_recording_video = not is_recording_video
end

wezterm.on("update-right-status", function(window, _)
	window:set_right_status(window:active_workspace())
end)

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font_size = font_size
-- config.window_background_opacity = window_background_opacity
-- config.macos_window_background_blur = window_background_blur

config.audible_bell = "Disabled"

-- Font
config.font = wezterm.font("FiraMono Nerd Font Mono")

-- TODO: remove this if it works through home-manager
-- Colors
-- config.color_scheme = "github_dark_colorblind"

-- Tab bar
config.use_fancy_tab_bar = false
config.mouse_wheel_scrolls_tabs = false
config.show_new_tab_button_in_tab_bar = false

-- Cursor
config.default_cursor_style = "SteadyBar"

-- Keymaps
config.leader = { key = " ", mods = "ALT" }
config.keys = {
	{ key = "n", mods = "SHIFT|CTRL", action = act.ToggleFullScreen },

	-- Panes
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Pane resizing/zooming/moving
	{ key = "<", mods = "LEADER", action = act.AdjustPaneSize({ "Left", PANE_SIZE_STEP }) },
	{ key = ">", mods = "LEADER", action = act.AdjustPaneSize({ "Right", PANE_SIZE_STEP }) },
	{ key = "+", mods = "LEADER", action = act.AdjustPaneSize({ "Up", PANE_SIZE_STEP }) },
	{ key = "-", mods = "LEADER", action = act.AdjustPaneSize({ "Down", PANE_SIZE_STEP }) },
	{ key = "x", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "m", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Move between panes
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "b", mods = "SHIFT|CTRL", action = act.MoveTabRelative(-1) },
	{ key = "f", mods = "SHIFT|CTRL", action = act.MoveTabRelative(1) },

	-- Deactivating conflicting keymaps for Neovim
	{ key = "-", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "+", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "+", mods = "SHIFT|CTRL", action = act.DisableDefaultAssignment },
	{ key = "=", mods = "CTRL", action = act.DisableDefaultAssignment },
	{ key = "_", mods = "CTRL", action = act.DisableDefaultAssignment },

	-- WezMux
	{ key = "9", mods = "ALT", action = act({ ShowLauncherArgs = { flags = "FUZZY|WORKSPACES" } }) },
	{ key = "n", mods = "ALT", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "ALT", action = act.SwitchWorkspaceRelative(-1) },

	-- Transparency and recording mode
	{ key = "t", mods = "LEADER", action = callback(toggle_transparency) },
	{ key = "r", mods = "LEADER", action = callback(toggle_recording_mode) },
}

return config
