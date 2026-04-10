hs.loadSpoon("AppLauncher")

local hyper = {"ctrl", "option"}

spoon.AppLauncher.modifiers = hyper

hs.spoons.use("AppLauncher", {
    hotkeys = {
        b = "Brave Browser",
        c = "Visual Studio Code",
        s = "Slack",
        t = "WezTerm",
    },
})
