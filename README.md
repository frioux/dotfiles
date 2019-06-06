# Charitable

Shared tags library for multiple monitors using AwesomeWM.

## Usage

```lua
local charitable = require("charitable")

-- Create tags and taglist
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) charitable.select_tag(t, awful.screen.focused()) end),

    awful.button({ }, 3, function(t) charitable.toggle_tag(t, awful.screen.focused()) end)
)

local tags = charitable.create_tags(
   { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
   {
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
   }
)

awful.screen.connect_for_each_screen(function(s)
    -- Show an unselected tag when a screen is connected
    for i = 1, #tags do
         if not tags[i].selected then
             tags[i].screen = s
             tags[i]:view_only()
             break
         end
    end

    -- create a special scratch tag for double buffering
    s.scratch = awful.tag.add('scratch-' .. s.index, {})

    s.mytaglist = awful.widget.taglist({
       screen = s,
       buttons = taglist_buttons,
       source = function(screen, args) return tags end,
    })

    -- ...
end

-- Keys setup
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function () charitable.select_tag(tags[i], awful.screen.focused()) end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function () charitable.toggle_tag(tags[i], awful.screen.focused()) end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- ensure that removing screens doesn't kill tags
tag.connect_signal("request::screen", function(t)
    t.selected = false
    for s in capi.screen do
        if s ~= t.screen then
            t.screen = s
            return
        end
    end
end)

-- work around bugs in awesome 4.0 through 4.3+
-- see https://github.com/awesomeWM/awesome/issues/2780
awful.tag.history.restore = function() end
```

## Description

Typical AwesomeWM configuration implies that tags are per screen.  This library
allows AwesomeWM to instead have tags that are shared across all connected
screens.  This is how XMonad works by default.

## Quick Reference

 * `charitable.create_tags` replaces [`awful.tag.new`](https://awesomewm.org/doc/api/classes/tag.html#awful.tag.new)
 * `charitable.select_tag` replaces [`t:view_only()`](https://awesomewm.org/doc/api/classes/tag.html#tag:view_only)
 * `charitable.toggle_tag` replaces [`awful.tag.viewtoggle`](https://awesomewm.org/doc/api/classes/tag.html#awful.tag.viewtoggle)
 * `charitable.tag_move` is new
 * `charitable.swap_screen` is new
 * `charitable.taglist.new` replaces [`awful.taglist`](https://awesomewm.org/doc/api/classes/awful.widget.taglist.html#awful.taglist)

## History

This was [originally](https://github.com/lammermann) implemented by Benjamin
Kober, and later [forked and updated](https://github.com/XLegion/sharetags) by
Alexey Solodkiy.  This version has been updated to support AwesomeWM 4.x, and
have a better name.
