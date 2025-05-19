local wezterm = require "wezterm"

local cfg = {}

-- Disable annoying default behaviors
cfg.adjust_window_size_when_changing_font_size = false

-- this one opens a separate win on first unknown glyph, stealing windows focus
cfg.warn_about_missing_glyphs = false

cfg.font_size = 16.0

-- Makes FontAwesome's double-width glyphs display properly!
cfg.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

local function get_font(font_family, weight)
  return wezterm.font({
    family = font_family,
    weight = weight or "Regular"
  })
end

local function font_and_rules_for_berkeley_mono()
  -- Use Retina weight (375) as the default
  local font = get_font("TX-02", 375)
  local font_rules = {
    {
      italic = true,
      font = get_font("TX-02", 375),
    },
    {
      italic = true, intensity = "Bold",
      font = get_font("TX-02", "Bold"),
    },
    {
      intensity = "Bold",
      font = get_font("TX-02", "Bold"),
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
