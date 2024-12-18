local wezterm = require 'wezterm'
local act = wezterm.action

return {
    leader = { mods = 'CTRL', key = 'a', timeout_milliseconds = 1000 },
    keys = {
        {
            key = 'r',
            mods = 'LEADER',
            action = act.ActivateKeyTable {
              name = 'resize_pane',
              one_shot = false,
            },
          },
        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
        { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = 'D', mods = 'CTRL', action = act.ShowDebugOverlay },
        { key = 'F', mods = 'CTRL', action = act.Search{ CaseInSensitiveString =  '' } },
        { key = 'L', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackAndViewport' },
        { key = 'R', mods = 'CTRL', action = act.ReloadConfiguration },
        { key = 'W', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = false } },
        { key = 'X', mods = 'CTRL', action = act.CloseCurrentPane{ confirm = false } },
        { key = '[', mods = 'SHIFT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
        { key = ']', mods = 'SHIFT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
        { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
        { key = 'h', mods = 'SUPER', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'SUPER', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'SUPER', action = act.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'SUPER', action = act.ActivatePaneDirection 'Right' },
        { key = 't', mods = 'SUPER', action = act.SpawnTab 'DefaultDomain' },
        { key = 'v', mods = 'ALT|CTRL', action = act.PasteFrom 'PrimarySelection' },
        { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
        -- Make SUPER-Left backward-word
        { key = 'LeftArrow', mods = 'SUPER', action = act.SendString '\x1bb' },
        -- Make SUPER-Right forward-word
        { key = 'RightArrow', mods = 'SUPER', action = act.SendString '\x1bf' },
        -- Make SHIFT|SUPER-Left beginning-of-line
        { key = 'LeftArrow', mods = 'SHIFT|SUPER', action = act.SendString '\x01' },
        -- Make SHIFT|SUPER-Right end-of-line
        { key = 'RightArrow', mods = 'SHIFT|SUPER', action = act.SendString '\x05' },
        -- Make SUPER-Backspace kill-word
        { key = 'Backspace', mods = 'SUPER', action = act.SendString '\x1bd' },
        -- Make SHIFT|SUPER-Backspace kill-line
        { key = 'Backspace', mods = 'SHIFT|SUPER', action = act.SendString '\x15' },
        { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
      },
      key_tables = {
        activate_pane = {
          { key = 'h', mods = 'NONE', action = act.ActivatePaneDirection 'Left' },
          { key = 'j', mods = 'NONE', action = act.ActivatePaneDirection 'Down' },
          { key = 'k', mods = 'NONE', action = act.ActivatePaneDirection 'Up' },
          { key = 'l', mods = 'NONE', action = act.ActivatePaneDirection 'Right' },
          { key = 'LeftArrow', mods = 'NONE', action = act.ActivatePaneDirection 'Left' },
          { key = 'RightArrow', mods = 'NONE', action = act.ActivatePaneDirection 'Right' },
          { key = 'UpArrow', mods = 'NONE', action = act.ActivatePaneDirection 'Up' },
          { key = 'DownArrow', mods = 'NONE', action = act.ActivatePaneDirection 'Down' },
        },

        copy_mode = {
          { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
          { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
          { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
          { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
          { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
          { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
          { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
          { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
          { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
          { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
          { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
          { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
          { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
          { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
          { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
          { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
          { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
          { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
          { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
          { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
          { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
          { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
          { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
          { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
          { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
          { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
          { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
          { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
          { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
          { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
          { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
          { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
          { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
          { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
          { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
          { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
          { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
          { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
          { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
          { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
          { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
          { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
          { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
          { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
          { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
          { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
          { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
          { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
          { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
          { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
          { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
          { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
          { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
          { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
          { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
          { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
          { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
          { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
          { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
          { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
          { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
          { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        },

        resize_pane = {
          { key = 'Escape', mods = 'NONE', action = act.PopKeyTable },
          { key = 'h', mods = 'NONE', action = act.AdjustPaneSize{ 'Left', 1 } },
          { key = 'j', mods = 'NONE', action = act.AdjustPaneSize{ 'Down', 1 } },
          { key = 'k', mods = 'NONE', action = act.AdjustPaneSize{ 'Up', 1 } },
          { key = 'l', mods = 'NONE', action = act.AdjustPaneSize{ 'Right', 1 } },
          { key = 'LeftArrow', mods = 'NONE', action = act.AdjustPaneSize{ 'Left', 1 } },
          { key = 'RightArrow', mods = 'NONE', action = act.AdjustPaneSize{ 'Right', 1 } },
          { key = 'UpArrow', mods = 'NONE', action = act.AdjustPaneSize{ 'Up', 1 } },
          { key = 'DownArrow', mods = 'NONE', action = act.AdjustPaneSize{ 'Down', 1 } },
        },

        search_mode = {
          { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
          { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
          { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
          { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
          { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
          { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
          { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
          { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
          { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
          { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
        },
      }
}
