-- functions to create modal keybindings in awesome

local keygrabber = require("keygrabber")
local naughty = require("naughty")

local pairs = pairs

module("modal")

local function dbg(title, msg)
    naughty.notify({
        title = title,
        text = msg,
        timeout = 10,
        position = "bottom_left",
    })
end

function modal_push(client_mode, c)
    keygrabber.run(function(mod, key, event)
        if event == "release" then return true end
        keygrabber.stop()
        if key == " " then
            key = "space"
        end
        --dbg("Debug", key)
        if client_mode[key] then client_mode[key](c) end
        return true
    end)
end

