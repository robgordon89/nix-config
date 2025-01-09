local hyper = {"ctrl", "option"}
local hyper_shift = {"ctrl", "shift"}

hs.hotkey.bind(hyper, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local half = max.w / 2

    f.x = max.x
    f.y = max.y
    f.w = half
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind(hyper, "Right", function()
    local win = hs.window.frontmostWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local half = max.w / 2

    f.x = half
    f.y = max.y
    f.w = half
    f.h = max.h
    win:setFrame(f, 0)
end)

hs.hotkey.bind(hyper, "Space", function()
    local win = hs.window.frontmostWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f, 0)
end)

hs.hotkey.bind(hyper_shift, "Space", function()
    local win = hs.window.frontmostWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f, 0)
end)

hs.hotkey.bind(hyper_shift, "Left", function()
    local win = hs.window.frontmostWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local fifths = max.w / 5
    local threefifths = fifths * 3

    f.x = max.x
    f.y = max.y
    f.w = threefifths
    f.h = max.h
    win:setFrame(f, 0)
end)

hs.hotkey.bind(hyper_shift, "Right", function()
    local win = hs.window.frontmostWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local fifths = max.w / 5
    local twofifths = fifths * 2
    local threefifths = fifths * 3

    f.x = threefifths
    f.y = max.y
    f.w = twofifths
    f.h = max.h
    win:setFrame(f, 0)
end)

function moveWindowToDisplay(d)
    return function()
      local displays = hs.screen.allScreens()
      local win = hs.window.focusedWindow()
      win:moveToScreen(displays[d], false, true)
    end
  end

hs.hotkey.bind(hyper_shift, "1", moveWindowToDisplay(1))
hs.hotkey.bind(hyper_shift, "2", moveWindowToDisplay(2))

-- hs.loadSpoon("WindowHalfsAndFifths")
