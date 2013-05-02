----------------------------------------------------------------------------
-- @author Zsolt Udvari &lt;udvzsolt@gmail.com&gt;
-- @copyright 2012-2013 Zsolt Udvari
-- @license GPLv2
-- @release 1.1
-- (tested with awesome 3.5)
----------------------------------------------------------------------------

-- Grab environment
local pairs     =   pairs
local type      =   type
local awful     =   require("awful")
local root      =   root
local naughty   =   require("naughty")

module("keychains")

-- variables
local keychain    = {}
local globalkeys  = {}
local chains      = {}
local notify      = nil
local menu        = nil
local options     = {}
-- the keygrabber object
local grabber

---
-- Parameters for function 'init'.
-- @field menu menu options
-- @field notify notify options
--
-- The options are awesome-compatible.
-- @see init
-- @table opt
---

---
-- Initialize the Keychain object.
--
-- @param globkeys the main root-hotkeys (without keychains!)
-- @param opt table of notify's and menu's options.
--
-- The 'text', 'icon', 'title' and 'timeout' fields in notify is ignored!
--
-- The options of notify and menu are awesome-compatible (see awesome's 
-- documentation).
-- @see opt
---
function init(globkeys,opt)
    globalkeys  = globkeys
    opt = opt or {}
    opt["notify"] = opt["notify"] or {}
    opt["menu"]   = opt["menu"] or {}
    -- the text, icon, title and timeout field is set at runtime
    local v
    for _,v in pairs({"text","icon","title","timeout"}) do
        opt["notify"][v] = nil
    end

    options["notify"] = opt["notify"]
    options["menu"]   = opt["menu"]

end

---
-- Starts the keychain-grabs.
---
function start()
    root.keys( awful.util.table.join(
        globalkeys,
        chains
    ))
end

---
-- Stop the keychain-grabs. It's very possible that you will not
-- use this function.
---
function stop()
    root.keys( globalkeys )
end

---
-- Hotkey table.
-- @field func function to call
-- @field info information to show
-- @table hotkeys
-- @see add
---

---
-- Add a new keychain-table.
-- @param mod_hk hotkey modifiers (table, same as in awful.key)
-- @param hk hotkey to jump into this hotkey-chain
-- @param title title of hotkeys
-- @param icon icon to show
-- @param hotkeys table, keys of table are hotkey.
-- @param style one of notify or menu (default is notify)
--
--  The param hotkeys can be a function which returns table as describe
--  in table hotkeys.
-- @see hotkeys
---
function add(mod_hk,hk,title,icon,hotkeys,style)
    local nr = #(keychain)+1
    keychain[nr] = keychain[nr] or {}
    keychain[nr].icon = icon
    keychain[nr].title = title
    keychain[nr].hotkeys = hotkeys
    keychain[nr].style = style or "notify"

    chains = awful.util.table.join(
        chains,
        awful.key(mod_hk,hk,function()
            activite(nr)
        end)
    )
end


---
-- Returns the hotkeys.
-- @param which which table
-- @return table.
-- If hotkeys is a function get_hotkeys will return hotkeys result else will return hotkeys.
---
function get_hotkeys(which)
    local ret
    if (type(keychain[which]["hotkeys"])=="function") then
        ret = keychain[which].hotkeys()
    else
        ret = keychain[which].hotkeys
    end
    return ret
end

---
-- Generate information about hotkeys
-- @param which which table
-- @return information string
---
function get_info(which)
    local i,hk
    local txt = ""
    local hotkeys = get_hotkeys(which)

    for i,hk in pairs(hotkeys) do
        txt = txt .. i .. " " ..
            (hk.info or awful.util.escape("[[ no description ]]")) .. "\n"
    end

    return txt
end

---
-- Generate menu
-- @param which which table
-- @return awful.menu
---
function get_menu(which)
    local i,hk
    local menu = {}
    local hotkeys = get_hotkeys(which)

    for i,hk in pairs(hotkeys) do
        menu[i] =
            {
                i .. " || " .. (hk.info or awful.util.escape("[[ no description ]]")),
                cmd = function()
                    reset()
                    hk.func()
                end,
            }
    end

    return awful.menu({
        items = menu,
        theme = options["menu"]
    })

end

---
-- Generate awful keys
-- @param which which hotkeys
-- @return awesome-compatible table
---
function get_awful_keys(which)
    local i, hkt,ret
    local hotkeys = get_hotkeys(which)

    ret = {}
    for i,hkt in pairs(hotkeys) do
        ret = awful.util.table.join(
            ret,
            awful.key({},i,function()
                reset()
                hkt.func()
            end)
        )
    end
    return ret
end

---
-- Activite a keychain and displays its information.
-- @param which which keychain should activite
---
function activite(which)


    local style = keychain[which].style or "notify"
    if (style=="menu") then
        menu = get_menu(which)
        menu:show()
    elseif (style=="notify") then
        notify = naughty.notify(awful.util.table.join(
            {
                title   = keychain[which].title,
                text    = get_info(which),
                icon    = keychain[which].icon,
                timeout = 0
            }, options["notify"]
        ))
    end

    grabber = awful.keygrabber.run(function(mod,key,event)
        local hotkeys = get_hotkeys(which)
        if event == "release" then return end
        if key == "Escape" then
            reset()
        elseif hotkeys[key] then
            reset()
            hotkeys[key].func()
        elseif menu then
            if key == "Up" or key == "Down" or key == "Return" then
                -- we will pass these keys to displayed 'menu'
                return false
            end
        else
            -- what do we if user press a bad key?
            -- maybe beep or similar or a user-specified function?
        end
    end)

end

---
-- Reset keychains.
-- Reset the hotkeys and destroy the keychain notify.
---
function reset()
    if grabber then
        awful.keygrabber.stop(grabber)
    end
    if naughty then
        naughty.destroy(notify)
    end
    if menu then
        menu:hide()
        -- we need to delete because 'activite' function checks it
        menu = nil
    end
end

