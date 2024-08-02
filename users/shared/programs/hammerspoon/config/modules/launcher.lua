hs.loadSpoon("AppLauncher")

local hyper = { "shift", "alt", "ctrl"}

spoon.AppLauncher.modifiers = hyper

hs.spoons.use("AppLauncher", {
    hotkeys = {
        b = "Safari",
        c = "Visual Studio Code",
        s = "Slack",
        m = "Beeper",
        t = "WezTerm",
    },
})
