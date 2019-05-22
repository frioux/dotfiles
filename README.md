Sharetags plugin for awesome wm
===============================

Shared tags for multi-monitor system

Usage:
```lua
local sharetags = require("sharetags")

-- Widget setup
local taglist = require("sharetags.taglist")
tags = sharetags.create_tags(
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
mytaglist = {}

awful.screen.connect_for_each_screen(function(s)
   s.mytaglist = taglist(tags, s, awful.widget.taglist.filter.all, taglist_buttons)
end

-- Keys setup

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = tags[i]
                        sharetags.select_tag(tag, screen)
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = tags[i]
                      sharetags.toggle_tag(tag, screen)
                  end,
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
```

  
