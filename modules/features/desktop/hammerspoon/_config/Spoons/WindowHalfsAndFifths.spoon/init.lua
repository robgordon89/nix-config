--- === WindowHalfsAndFifths ===
---
--- Simple window movement and resizing, focusing on half- and third-of-screen sizes
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WindowHalfsAndFifths.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WindowHalfsAndFifths.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "WindowHalfsAndFifths"
obj.version = "0.1"
obj.author = "Robert Gordon <rob@ruled.io>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- WindowHalfsAndFifths.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('WindowHalfsAndFifths')

--- WindowHalfsAndFifths.defaultHotkeys
--- Variable
--- Table containing a sample set of hotkeys that can be
--- assigned to the different operations. These are not bound
--- by default - if you want to use them you have to call:
--- `spoon.WindowHalfsAndFifths:bindHotkeys(spoon.WindowHalfsAndFifths.defaultHotkeys)`
--- after loading the spoon. Value:
--- ```
---  {
---     left_half   = { {"ctrl",        "cmd"}, "Left" },
---     right_half  = { {"ctrl",        "cmd"}, "Right" },
---     top_half    = { {"ctrl",        "cmd"}, "Up" },
---     bottom_half = { {"ctrl",        "cmd"}, "Down" },
---     fifth_left  = { {"ctrl", "alt"       }, "Left" },
---     fifth_right = { {"ctrl", "alt"       }, "Right" },
---     fifth_up    = { {"ctrl", "alt"       }, "Up" },
---     fifth_down  = { {"ctrl", "alt"       }, "Down" },
---     top_left    = { {"ctrl",        "cmd"}, "1" },
---     top_right   = { {"ctrl",        "cmd"}, "2" },
---     bottom_left = { {"ctrl",        "cmd"}, "3" },
---     bottom_right= { {"ctrl",        "cmd"}, "4" },
---     max_toggle  = { {"ctrl", "alt", "cmd"}, "f" },
---     max         = { {"ctrl", "alt", "cmd"}, "Up" },
---     undo        = { {        "alt", "cmd"}, "z" },
---     center      = { {        "alt", "cmd"}, "c" },
---     larger      = { {        "alt", "cmd", "shift"}, "Right" },
---     smaller     = { {        "alt", "cmd", "shift"}, "Left" },
---  }
--- ```
obj.defaultHotkeys = {
   left_half    = { {"ctrl",        "cmd"}, "Left" },
   right_half   = { {"ctrl",        "cmd"}, "Right" },
   fifth_left   = { {"ctrl", "shift"}, "Left" },
   fifth_right  = { {"ctrl", "alt"       }, "Right" },
   max_toggle   = { {"ctrl", "alt", "cmd"}, "f" },
   max          = { {"ctrl", "alt", "cmd"}, "Up" },
   undo         = { {        "alt", "cmd"}, "z" },
   center       = { {        "alt", "cmd"}, "c" },
   larger       = { {        "alt", "cmd", "shift"}, "Right" },
   smaller      = { {        "alt", "cmd", "shift"}, "Left" },
}

--- WindowHalfsAndFifths.use_frame_correctness
--- Variable
--- If `true`, set [setFrameCorrectness](http://www.hammerspoon.org/docs/hs.window.html#setFrameCorrectness) for some resizing operations which fail when the window extends beyonds screen boundaries. This may cause some jerkiness in the resizing, so experiment and determine if you need it. Defaults to `false`
obj.use_frame_correctness = false

--- WindowHalfsAndFifths.clear_cache_after_seconds
--- Variable
--- We don't want our undo frame cache filling all available memory. Let's clear it after it hasn't been used for a while.
obj.clear_cache_after_seconds = 60

-- Internal terminology:
-- `actions` are the things hotkeys are bound to and express a user desire (eg. `fifth_left`: move a fifth further left
--   than the current `window_state`). See the keys of obj._window_moves or the keys of action_to_method_map in
--   :bindHotkeys() for the available actions
-- `window_states` are states a window may be currently in (eg. `left_fifth`: the leftmost horizontal fifth of the screen)
-- sometimes `actions` and `window_states` share a name (eg. `left_half`)
-- sometimes `actions` and `window_states` don't share a name (`fifth_left`: `left_fifth`, `middle_fifth_h`, `right_fifth`)
--
-- `window_state_names` are states windows can be in (so since `fifth_left` implies a relative move there is no `fifth_left`
--   `window_state_name`, only a `fifth_left` `action`)
-- `window_state_rects` are `{x,y,w,l}` `hs.geometry.unitrect` tables defining those states
obj._window_state_name_to_rect = {
   left_half        = {0.00,0.00,0.50,1.00}, -- two decimal places required for `window_state_rect_strings` to match
   right_half       = {0.50,0.00,0.50,1.00},
   left_fifth       = {0.00,0.00,0.20,1.00},
   right_fifth      = {0.80,0.00,0.20,1.00},
   left_four_fifth  = {0.00,0.00,0.80,1.00},
   right_four_fifth = {0.20,0.00,0.80,1.00},
   max              = {0.00,0.00,1.00,1.00},
}

-- `window_state_rect_strings` because Lua does table identity comparisons in table keys instead of table content
--   comparisons; that is, table["0.00,0.00,0.50,1.00"] works where table[{0.00,0.00,0.50,1.00}] doesn't
obj._window_state_rect_string_to_name = {}
for state,rect in pairs(obj._window_state_name_to_rect) do
   obj._window_state_rect_string_to_name[table.concat(rect,",")] = state
end

-- `window_moves` are `action` to `window_state_name` pairs
--   `action` = {[`window_state_name` default], [if current `window_state_name`] = [then new `window_state_name`], ...}
--   so if a user takes `action` from `window_state_name` with a key, move to the paired value `window_state_name`,
--   or the default `window_state_name` the current `window_state_name` isn't a key for that `action`
--   (example below)
obj._window_moves = {
   half_left = {"left_half"},
   half_right = {"right_half"},

   left_fifth = {"left_fifth"},
   right_fifth = {"right_fifth"},

   left_four_fifth = {"left_four_fifth"},
   right_four_fifth = {"right_four_fifth"},

   max = {"max"},
}

-- Private utility functions

local function round(x, places)
   local places = places or 0
   local x = x * 10^places
   return (x + 0.5 - (x + 0.5) % 1) / 10^places
end

local function current_window_rect(win)
   local win = win or hs.window.focusedWindow()
   local ur, r = win:screen():toUnitRect(win:frame()), round
   return {r(ur.x,2), r(ur.y,2), r(ur.w,2), r(ur.h,2)} -- an hs.geometry.unitrect table
end

local function current_window_state_name(win)
   local win = win or hs.window.focusedWindow()
   return obj._window_state_rect_string_to_name[table.concat(current_window_rect(win),",")]
end

local function cacheWindow(win, move_to)
   local win = win or hs.window.focusedWindow()
   if (not win) or (not win:id()) then return end
   obj._frameCache[win:id()] = win:frame()
   obj._frameCacheClearTimer:start()
   obj._lastMoveCache[win:id()] = move_to
   return win
end

local function restoreWindowFromCache(win)
   local win = win or hs.window.focusedWindow()
   if (not win) or (not win:id()) or (not obj._frameCache[win:id()]) then return end
   local current_window_frame = win:frame()         -- enable undoing an undo action
   win:setFrame(obj._frameCache[win:id()])
   obj._frameCache[win:id()] = current_window_frame -- enable undoing an undo action
   return win
end

function obj.script_path_raw(n)
   return (debug.getinfo(n or 2, "S").source)
end
function obj.script_path(n)
   local str = obj.script_path_raw(n or 2):sub(2)
   return str:match("(.*/)")
end
function obj.generate_docs_json()
   io.open(obj.script_path().."docs.json","w"):write(hs.doc.builder.genJSON(obj.script_path())):close()
end

-- Internal functions to store/restore the current value of setFrameCorrectness.
local function _setFrameCorrectness()
   obj._savedFrameCorrectness = hs.window.setFrameCorrectness
   hs.window.setFrameCorrectness = obj.use_frame_correctness
end
local function _restoreFrameCorrectness()
   hs.window.setFrameCorrectness = obj._savedFrameCorrectness
end


-- --------------------------------------------------------------------
-- Base window resizing and moving functions
-- --------------------------------------------------------------------


-- Resize current window to different parts of the screen
-- If use_frame_correctness_preference is true, then use setFrameCorrectness according to the
-- configured value of `WindowHalfsAndFifths.use_frame_correctness`
function obj.resizeCurrentWindow(how, use_frame_correctness_preference)
   local win = hs.window.focusedWindow()
   if not win then return end

   local move_to = obj._lastMoveCache[win:id()] and obj._window_moves[how][obj._lastMoveCache[win:id()]] or
      obj._window_moves[how][current_window_state_name(win)] or obj._window_moves[how][1]
   if not move_to then
      obj.logger.e("I don't know how to move ".. how .." from ".. (obj._lastMoveCache[win:id()] or
         current_window_state_name(win)))
   end
   if current_window_state_name(win) == move_to then return end
   local move_to_rect = obj._window_state_name_to_rect[move_to]
   if not move_to_rect then
      obj.logger.e("I don't know how to move to ".. move_to)
      return
   end

   if use_frame_correctness_preference then _setFrameCorrectness() end
   cacheWindow(win, move_to)
   win:move(move_to_rect)
   if use_frame_correctness_preference then _restoreFrameCorrectness() end
end

-- --------------------------------------------------------------------
-- Action functions for obj.resizeCurrentWindow, for the hotkeys
-- --------------------------------------------------------------------

--- WindowHalfsAndFifths:leftHalf(win)
--- Method
--- Resize to the left half of the screen.
---
--- Parameters:
---  * win - hs.window to use, defaults to hs.window.focusedWindow()
---
--- Returns:
---  * the WindowHalfsAndFifths object
---
--- Notes:
---  * Variations of this method exist for other operations. See WindowHalfsAndFifths:bindHotkeys for details:
---    * .leftHalf .rightHalf .topHalf .bottomHalf .thirdLeft .thirdRight .leftThird .middleThirdH .rightThird
---    * .thirdUp .thirdDown .topThird .middleThirdV .bottomThird .topLeft .topRight .bottomLeft .bottomRight
---    * .maximize

obj.leftHalf       = hs.fnutils.partial(obj.resizeCurrentWindow, "left_half")
obj.rightHalf      = hs.fnutils.partial(obj.resizeCurrentWindow, "right_half")
obj.fifthLeft      = hs.fnutils.partial(obj.resizeCurrentWindow, "fifth_left")
obj.fifthRight     = hs.fnutils.partial(obj.resizeCurrentWindow, "fifth_right")
obj.leftFourFifth   = hs.fnutils.partial(obj.resizeCurrentWindow, "left_four_fifth")
obj.rightFourFifth  = hs.fnutils.partial(obj.resizeCurrentWindow, "right_four_fifth")
obj.maximize       = hs.fnutils.partial(obj.resizeCurrentWindow, "max", true)


--- WindowHalfsAndFifths:toggleMaximized(win)
--- Method
--- Toggle win between its normal size, and being maximized
---
--- Parameters:
---  * win - hs.window to use, defaults to hs.window.focusedWindow()
---
--- Returns:
---  * the WindowHalfsAndFifths object
function obj.toggleMaximized(win)
   local win = win or hs.window.focusedWindow()
   if (not win) or (not win:id()) then
      return
   end
   if current_window_state_name() == "max" then
      restoreWindowFromCache(win)
   else
      cacheWindow(win, "max")
      win:maximize()
   end
   return obj
end

--- WindowHalfsAndFifths:undo(win)
--- Method
--- Undo window size changes for win if there've been any in WindowHalfsAndFifths.clear_cache_after_seconds
---
--- Parameters:
---  * win - hs.window to use, defaults to hs.window.focusedWindow()
---
--- Returns:
---  * the WindowHalfsAndFifths object
function obj.undo(win)
   restoreWindowFromCache(win)
   return obj
end

--- WindowHalfsAndFifths:center(win)
--- Method
--- Center window on screen
---
--- Parameters:
---  * win - hs.window to use, defaults to hs.window.focusedWindow()
---
--- Returns:
---  * the WindowHalfsAndFifths object
function obj.center(win)
   local win = win or hs.window.focusedWindow()
   if win then
      cacheWindow(win, "center")
      win:centerOnScreen()
   end
   return obj
end

--- WindowHalfsAndFifths:larger(win)
--- Method
--- Make win larger than its current size
---
--- Parameters:
---  * win - hs.window to use, defaults to hs.window.focusedWindow()
---
--- Returns:
---  * the WindowHalfsAndFifths object
function obj.larger(win)
   local win = win or hs.window.focusedWindow()
   if win then
      cacheWindow(win, nil)
      local cw = current_window_rect(win)
      local move_to_rect = {}
      move_to_rect[1] = math.max(cw[1]-0.02,0)
      move_to_rect[2] = math.max(cw[2]-0.02,0)
      move_to_rect[3] = math.min(cw[3]+0.04,1 - move_to_rect[1])
      move_to_rect[4] = math.min(cw[4]+0.04,1 - move_to_rect[2])
      win:move(move_to_rect)
   end
   return obj
end

--- WindowHalfsAndFifths:smaller(win)
--- Method
--- Make win smaller than its current size
---
--- Parameters:
---  * win - hs.window to use, defaults to hs.window.focusedWindow()
---
--- Returns:
---  * the WindowHalfsAndFifths object
function obj.smaller(win)
   local win = win or hs.window.focusedWindow()
   if win then
      cacheWindow(win, nil)
      local cw = current_window_rect(win)
      local move_to_rect = {}
      move_to_rect[3] = math.max(cw[3]-0.04,0.1)
      move_to_rect[4] = cw[4] > 0.95 and 1 or math.max(cw[4]-0.04,0.1) -- some windows (MacVim) don't size to 1
      move_to_rect[1] = math.min(cw[1]+0.02,1 - move_to_rect[3])
      move_to_rect[2] = cw[2] == 0 and 0 or math.min(cw[2]+0.02,1 - move_to_rect[4])
      win:move(move_to_rect)
   end
   return obj
end

--- WindowHalfsAndFifths:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WindowHalfsAndFifths
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---   * left_half, right_half, top_half, bottom_half - resize to the corresponding half of the screen
---   * third_left, third_right - resize to one horizontal-third of the screen and move left/right
---   * third_up, third_down - resize to one vertical-third of the screen and move up/down
---   * max - maximize the window
---   * max_toggle - toggle maximization
---   * left_third, middle_third_h, right_third - resize and move the window to the corresponding horizontal third of the screen
---   * top_third, middle_third_v, bottom_third - resize and move the window to the corresponding vertical third of the screen
---   * top_left, top_right, bottom_left, bottom_right - resize and move the window to the corresponding quarter of the screen
---   * undo - restore window to position before last move
---   * center - move window to center of screen
---   * larger - grow window larger than its current size
---   * smaller - shrink window smaller than its current size
---
--- Returns:
---  * the WindowHalfsAndFifths object
function obj:bindHotkeys(mapping)
   local action_to_method_map = {
      left_half = self.leftHalf,
      half_left = self.halfLeft,
      fifth_left = self.fifthLeft,
      fifth_right = self.fifthRight,
      max = self.maximize,
      left_four_fifth = self.leftFourFifth,
      right_two_fifth = self.rightFourFifth,
      center = self.center,
      larger = self.larger,
      smaller = self.smaller,
   }
   hs.spoons.bindHotkeysToSpec(action_to_method_map, mapping)
   return self
end

function obj:init()
   self._frameCache = {}
   obj._lastMoveCache = {}
   self._frameCacheClearTimer = hs.timer.delayed.new(obj.clear_cache_after_seconds,
      function() obj._frameCache = {}; obj._lastMoveCache = {} end)
end

return obj
