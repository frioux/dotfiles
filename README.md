sharetags
=========

Shared tags for multi-monitor system

Usage:
```lua
local sharetags = require("sharetags")

-- Widget setup
local sharetags_taglist = require("sharetags.taglist")
tags = sharetags.create_tags(tags_names, tags_layout)
mytaglist = {}
for s = 1, screen.count() do
    -- Create a taglist widget
    --mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, buttons)
    mytaglist[s] = sharetags_taglist(tags, s, awful.widget.taglist.filter.all, buttons)
end



-- Keys setup

-- 1-9
local keys = {"#10", "#11", "#12", "#13", "#14", "#15", "#16", "#17", "#18"}

for i, key in ipairs(keys) do
        globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, key,
                  function ()
                      local screen = mouse.screen
                      local tag = tags[i]
                      sharetags.select_tag(tag, screen)

                  end),
        awful.key({ modkey, "Control" }, key,
                  function ()
                      local screen = mouse.screen
                      local tag = tags[i]
                      sharetags.toggle_tag(tag, screen)
                  end),
        awful.key({ modkey, "Shift" }, key,
                  function ()
                      if client.focus then
                          local tag = tags[i]
                          awful.client.movetotag(tag)
                     end
                  end)
        )
end
```

  
