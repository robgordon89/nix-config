local wezterm = require 'wezterm'

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return '3024 Night'
  else
    return '3024 Day'
  end
end

function window_frame_for_appearance(appearance)
    if appearance:find 'Dark' then
      return {
        inactive_titlebar_bg = '#000',
        active_titlebar_bg = '#000',
        inactive_titlebar_fg = '#cccccc',
        active_titlebar_fg = '#ffffff',
        inactive_titlebar_border_bottom = '#2b2042',
        active_titlebar_border_bottom = '#2b2042',
        button_fg = '#cccccc',
        button_bg = '#2b2042',
        button_hover_fg = '#ffffff',
        button_hover_bg = '#3b3052',
        split = '#437487',
      }
    end
    return {
        inactive_titlebar_bg = '#fff',
        active_titlebar_bg = '#fff',
        inactive_titlebar_fg = '#cccccc',
        active_titlebar_fg = '#ffffff',
        inactive_titlebar_border_bottom = '#2b2042',
        active_titlebar_border_bottom = '#2b2042',
        button_fg = '#cccccc',
        button_bg = '#2b2042',
        button_hover_fg = '#ffffff',
        button_hover_bg = '#3b3052',
        }
  end

return {
  window_frame = window_frame_for_appearance(get_appearance()),
  color_scheme = scheme_for_appearance(get_appearance()),
  current_apperance = get_appearance(),
}
