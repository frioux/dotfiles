-- functions to share tags on multiple screens

--{{{ Grab environment we need
local capi = { widget = widget,
               screen = screen,
               image = image,
               client = client,
               button = button }
local math = math
local type = type
local setmetatable = setmetatable
local pcall = pcall
local pairs = pairs
local ipairs = ipairs
local table = table
local common = require("awful.widget.common")
local util = require("awful.util")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local fixed = require("wibox.layout.fixed")
local surface = require("gears.surface")

local awful = require("awful") 
local mouse = mouse

--local naughty = require("naughty")

--local inspect = require("inspect")
--}}}

module("sharetags")

--[[
function dump(data)
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "",
        text = inspect(data) })
end
]]

--{{{ Private structures
tagwidgets = setmetatable({}, { __mode = 'k' })
local cachedtags = {}
label = {}
--}}}

--{{{ Functions

--{{{ create_tags: create a table of tags and bind them to screens
-- @param names : list to label the tags
-- @param layouts : list of layouts for the tags
-- @return table of tag objects
function create_tags(names, layouts)
    local tags = {}
    local count = #names
    if capi.screen.count() >= #names then
        count = capi.screen.count() + 1
    end

    for tagnumber = 1, count do
        tags[tagnumber] = awful.tag.add(names[tagnumber], {})
        tag.setproperty(tags[tagnumber], "number", tagnumber)
        -- Add tags to screen one by one
        tag.setscreen(tags[tagnumber], 1)

        awful.layout.set(layouts[tagnumber], tags[tagnumber])
    end
    --[[
    for s = 1, capi.screen.count() do
        -- I'm sure you want to see at least one tag.
        tag.setscreen(tags[s], s)
        tags[s].selected = true
    end
    --]]
    cachedtags = tags
    return tags
end
--}}}

--{{{ tag_move: move a tag to a screen
-- @param t : the tag object to move
-- @param scr : the screen object to move to
function tag_move(t, scr)
    local ts = t or awful.tag.selected()

    if not scr then return end
    local screen_target = scr or awful.util.cycle(capi.screen.count(), tag.getscreen(ts) + 1)

    if tag.getscreen(ts) and screen_target ~= tag.getscreen(ts) then
        -- switch for tag
        local mynumber = tag.getproperty(ts, "number")

        -- sort tags
        local index = #tag.gettags(screen_target)+1
        for i, screen_tag in pairs(tag.gettags(screen_target)) do
            local number = tag.getproperty(screen_tag, "number")
            if (mynumber < number) then
                index = i
                break
            end
        end
        tag.setscreen(ts, screen_target)
        tag.move(index, ts)


        -- switch for all clients on tag
        if #ts:clients() > 0 then
            for _ , c in ipairs(ts:clients()) do
                if not c.sticky then
                    c.screen = screen_target
                    c:tags( {ts} )
                else
                    awful.client.toggletag(ts,c)
                end
            end
        end
    end
end
--}}}

--{{{ tag_to_screen: move a tag to a screen if its not already there
-- @param t : the tag object to move
-- @param scr : the screen object to move to
function tag_to_screen(t, scr)
    local ts = t or awful.tag.selected()
    local screen_origin = tag.getscreen(ts)
    local screen_target = scr or awful.util.cycle(capi.screen.count(), tag.getscreen(ts) + 1)

    awful.tag.history.restore(tag.getscreen(ts), 1)
    -- move the tag only if we are on a different screen
    if screen_origin ~= screen_target then
        tag_move(ts, screen_target)
    end


    awful.tag.viewonly(ts)
    mouse.screen = tag.getscreen(ts)
    if #ts:clients() > 0 then
        local c = ts:clients()[1]
        capi.client.focus = c
    end
end
--}}}


