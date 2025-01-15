local wezterm = require "wezterm"
local act = wezterm.action

local function act_callback(event_id, callback)
    wezterm.log_info(">> wezterm.action_callback is available for this version, use it!")
    return wezterm.action_callback(callback)
end

-- IDEA: helper for keybind definition
local function keybind(mods, key, action)
  return {mods = mods, key = key, action = action}
end

local ctrl_shift = "CTRL|SHIFT"

local cfg = {}

cfg.disable_default_key_bindings = true

cfg.keys = {

  -- Wezterm features
  keybind(ctrl_shift, "r", 'ReloadConfiguration'),
  keybind(ctrl_shift, "l", wezterm.action.ClearScrollback 'ScrollbackAndViewport'),
  keybind(ctrl_shift, "f", wezterm.action.Search { CaseInSensitiveString = '' }),
  keybind(ctrl_shift, "d", "ShowDebugOverlay"), -- note: it's not a full Lua interpreter

  -- Copy/Paste to/from Clipboard
  keybind("CMD", "c", wezterm.action.CopyTo "Clipboard"),
  keybind("CMD", "v", wezterm.action.PasteFrom "Clipboard"),
  -- Paste from PrimarySelection (Copy is done by selection)
  keybind("SHIFT", "Insert", act{PasteFrom = "PrimarySelection"}),
  keybind("CTRL|ALT", "v",      act{PasteFrom = "PrimarySelection"}),
  -- NOTE: that last one eats a valid terminal keybind

  -- Tabs
  keybind("CMD", "t", act{SpawnTab="DefaultDomain"}), -- Ctrl-Shift-t
  keybind("CTRL", "Tab", act{ActivateTabRelative=1}),
  keybind(ctrl_shift, "Tab", act{ActivateTabRelative=-1}),
  keybind(ctrl_shift, "w", act{CloseCurrentTab={confirm=false}}),

  keybind(ctrl_shift, "x", "ShowLauncher"),

  -- Font size
  keybind("CTRL", "0", "ResetFontSize"), -- Ctrl-Shift-0
  keybind("CTRL", "+", "IncreaseFontSize"), -- Ctrl-Shift-+
  keybind("CTRL", "6", "DecreaseFontSize"), -- Ctrl-Shift-- (key with -)

  ---- Pane events
  keybind(ctrl_shift, "[", wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })), -- Ctrl-Shift [
  keybind(ctrl_shift, "]", wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })), -- Ctrl-Shift ]

  keybind(ctrl_shift, "x", wezterm.action.CloseCurrentPane { confirm = false }),

  keybind("CMD", "h", act{ActivatePaneDirection="Left"}),
  keybind("CMD", "j", act{ActivatePaneDirection="Down"}),
  keybind("CMD", "k", act{ActivatePaneDirection="Up"}),
  keybind("CMD", "l", act{ActivatePaneDirection="Right"}),
  keybind(ctrl_shift, "LeftArrow", act{ActivatePaneDirection="Left"}),
  keybind(ctrl_shift, "DownArrow", act{ActivatePaneDirection="Down"}),
  keybind(ctrl_shift, "UpArrow", act{ActivatePaneDirection="Up"}),
  keybind(ctrl_shift, "RightArrow", act{ActivatePaneDirection="Right"}),
}

cfg.key_tables = {
	resize_pane = {
		{ key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h",          action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l",          action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k",          action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j",          action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "Escape",     action = "PopKeyTable" },
	},
	activate_pane = {
		{ key = "LeftArrow",  action = act.ActivatePaneDirection("Left") },
		{ key = "h",          action = act.ActivatePaneDirection("Left") },
		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l",          action = act.ActivatePaneDirection("Right") },
		{ key = "UpArrow",    action = act.ActivatePaneDirection("Up") },
		{ key = "k",          action = act.ActivatePaneDirection("Up") },
		{ key = "DownArrow",  action = act.ActivatePaneDirection("Down") },
		{ key = "j",          action = act.ActivatePaneDirection("Down") },
	},
}

return cfg
