local wezterm = require "wezterm"

local cfg = {}

-- Disable annoying default behaviors
cfg.adjust_window_size_when_changing_font_size = false

-- this one opens a separate win on first unknown glyph, stealing windows focus
cfg.warn_about_missing_glyphs = false

cfg.font_size = 16.0

-- Makes FontAwesome's double-width glyphs display properly!
cfg.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- Additional font directory (necessary to find FontAwesome font!)
cfg.font_dirs = {"fonts"} -- relative to main config file

local function font_with_fallback(font_family)
  -- family names, not file names
  return wezterm.font_with_fallback({
    font_family,
    "Font Awesome 5 Free Solid", -- nice double-spaced symbols!
  })
end

local function font_and_rules_for_berkeley_mono()
  -- Use a _very slightly_ lighter variant, so that regular bold really stand out
  local font = font_with_fallback("TX-02")
  local font_rules = {
    {
      italic = true,
      font = font_with_fallback("TX-02"),
    },
    {
      italic = true, intensity = "Bold",
      font = font_with_fallback("TX-02"),
    },
    {
      intensity = "Bold",
      font = font_with_fallback("TX-02"),
    },
  }
  return font, font_rules
end

cfg.font, cfg.font_rules = font_and_rules_for_berkeley_mono()

cfg.harfbuzz_features = {
  "liga", -- (default) ligatures
  "clig", -- (default) contextual ligatures
}

return cfg
