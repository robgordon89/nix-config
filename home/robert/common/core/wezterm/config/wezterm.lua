local wezterm = require 'wezterm';
local mytable = require "lib/mystdlib".mytable
local color_scheme = require "color_scheme"

local mux = wezterm.mux

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window{}
    window:gui_window():maximize()
  end)

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
    local name = window:active_key_table()
    if name then
      name = 'TABLE: ' .. name
    end
    window:set_right_status(name or '')
  end)

local cfg_misc = {
  window_close_confirmation = "NeverPrompt",
  check_for_updates = false,
  window_decorations = "RESIZE",
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
    brightness = 0.6,
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
