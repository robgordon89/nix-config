local wezterm = require 'wezterm';
local mytable = require "lib/mystdlib".mytable
local color_scheme = require "color_scheme"

local mux = wezterm.mux

local cache_dir = os.getenv('HOME') .. '/.cache/wezterm/'
local window_size_cache_path = cache_dir .. 'window_size_cache.txt'

wezterm.on("gui-startup", function()
	os.execute("mkdir " .. cache_dir)

	-- local window_size_cache_file = io.open(window_size_cache_path, "r")
	-- local window
	-- if window_size_cache_file ~= nil then
	-- 	_, _, width, height = string.find(window_size_cache_file:read(), "(%d+),(%d+)")
	-- 	_, _, window = mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
	-- 	window_size_cache_file:close()
	-- else
	-- 	_, _, window = mux.spawn_window({})
	-- 	window:gui_window():maximize()
	-- end
end)

wezterm.on("window-resized", function(_, pane)
    local tab_size = pane:tab():get_size()
    local cols = tab_size["cols"]
    local rows = tab_size["rows"] + 2 -- Without adding the 2 here, the window doesn't maximize
    x, y = window:get_position()
    local contents = string.format("%d,%d,%d,%d", cols, rows, x, y)

    local window_size_cache_file = io.open(window_size_cache_path, "w")
    -- Check if the file was successfully opened
    if window_size_cache_file then
        window_size_cache_file:write(contents)
        window_size_cache_file:close()
    else
        print("Error: Could not open file for writing: " .. window_size_cache_path)
    end
end)

local cfg_misc = {
  window_close_confirmation = "NeverPrompt",
  check_for_updates = false,
  window_decorations = "RESIZE|MACOS_FORCE_SQUARE_CORNERS",
  -- Automatically reload the configuration when it changes on disk
  automatically_reload_config = true,

  -- Selection word boundary
  selection_word_boundary = " \t\n{}[]()\"'`,;:@",

  hide_tab_bar_if_only_one_tab = true,

  exit_behavior = "Close",

  window_padding = {
    left = 8, right = 8,
    top = 8, bottom = 8,
  },

  inactive_pane_hsb = {
    brightness = 0.5,
  },
  front_end = "WebGpu",
}

local cfg_fonts = require("cfg_fonts")

-- Key/Mouse bindings
------------------------------------------

-- Key bindings
local cfg_key_bindings = require("cfg_keys")

-- import custom key bindings
local custom_key_bindings = require("keybindings")
merged_key_bindings = mytable.merge_all(
  cfg_key_bindings,
  custom_key_bindings
)

local cfg_unix = {
    unix_domains = { { name = "unix" } },
    default_gui_startup_args  = { "connect", "unix" }
}

local config = mytable.merge_all(
  cfg_misc,
  cfg_fonts,
  merged_key_bindings
)

function scheme_for_appearance(appearance)
    if appearance:find("Dark") then
      return "Black Metal (Mayhem) (base16)"
    else
      return "Builtin Solarized Light"
    end
end

wezterm.on("window-config-reloaded", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    local appearance = window:get_appearance()
    local scheme = scheme_for_appearance(appearance)
    wezterm.log_info 'Hello!'
    if appearance:find("Dark") then
        os.execute("ln -sf ~/.config/k9s/skins/dark.yaml ~/.config/k9s/skins/active.yaml")
    else
        os.execute("ln -sf ~/.config/k9s/skins/light.yaml ~/.config/k9s/skins/active.yaml")
    end
    if overrides.color_scheme ~= scheme then
        overrides.color_scheme = scheme
        window:set_config_overrides(overrides)
    end
end)

config.leader = { key="a", mods="CTRL", timeout_milliseconds=1000 }
config.color_scheme = 'Black Metal (Mayhem) (base16)'

return config
