-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("sharetags")
require("utils")
local cal = utils.cal
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
local vicious = require("vicious")

warn = function(str)
   io.stderr:write(str .. "\n")
   io.stderr:flush()
   naughty.notify({
      preset = naughty.config.presets.critical,
      title = "warning",
      text = str
   })
end
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.border_focus = '#FF0000'
beautiful.border_normal = '#AAAAAA'

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = sharetags.create_tags({
   1, 2, 3, 4, 5, 6, 7, 8, 9
}, {
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1],
   layouts[1]
})
-- }}}

-- {{{ helpers
function exists(filename)
  local file = io.open(filename)
  if file then
    io.close(file)
    return true
  else
    return false
  end
end

local has_battery = exists('/home/frew/.config/laptop/battery')
local has_thermal = exists('/home/frew/.config/laptop/temperature')

weather_widget = function(
   code,
   url,
   name
)
   local actual_widget = widget({ type = "textbox" })
   local actual_tooltip = awful.tooltip({ objects = { actual_widget } });

   actual_widget:buttons(awful.util.table.join(
      awful.button({}, 1, function () awful.util.spawn("firefox '" .. url .. os.time() .. "'") end)
   ))

   vicious.register(actual_widget, vicious.widgets.weather,
      function (widget, args)
        actual_tooltip:set_text(
           "City: " .. args["{city}"] ..
           "\nWind: " .. args["{windmph}"] .. "mph " ..
           "\nSky: " .. args["{sky}"] ..
           "\nHumidity: " .. args["{humid}"] .. "%" ..
           "\nMeasured At: " .. args["{time}"])
        return name .. " " .. args["{tempf}"] .. "°F"
   end, 60 * 10, code)

   return actual_widget
end
-- }}}

-- {{{ widgets

-- {{{ Volume widget

volumecfg = {}
volumecfg.cardid  = 0
volumecfg.channel = "Master"
volumecfg.widget = awful.widget.progressbar()
volumecfg.widget:set_max_value(100)
volumecfg.widget:set_color('#FFFFFF')
volumecfg.widget:set_width(8)
volumecfg.widget:set_vertical(true)

volumecfg_t = awful.tooltip({ objects = { volumecfg.widget.widget },})

-- command must start with a space!
volumecfg.mixercommand = function (command)
       local fd = io.popen("amixer -c " .. volumecfg.cardid .. command)
       local status = fd:read("*all")
       fd:close()

       local volume = string.match(status, "(%d?%d?%d)%%") or 0
       volume = string.format("% 3d", volume)
       status = string.match(status, "%[(o[^%]]*)%]") or ''
       volumecfg.widget:set_value(volume)
       if string.find(status, "on", 1, true) then
          volumecfg.widget:set_color('#FFFFFF')
          volumecfg_t:set_text("Volume: " .. volume .. '%')
       else
          volumecfg.widget:set_color('#FF0000')
          volumecfg_t:set_text("Volume: " .. volume .. '%, muted')
       end
end
volumecfg.update = function ()
       volumecfg.mixercommand(" sget " .. volumecfg.channel)
end
volumecfg.up = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1%+")
end
volumecfg.down = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1%-")
end
volumecfg.toggle = function ()
       volumecfg.mixercommand(" sset " .. volumecfg.channel .. " toggle")
end
volumecfg.widget.widget:buttons(awful.util.table.join(
       awful.button({ }, 4, function () volumecfg.up() end),
       awful.button({ }, 5, function () volumecfg.down() end),
       awful.button({ }, 1, function () volumecfg.toggle() end)
))
volumecfg.update()
-- }}}

-- {{{ battery
if has_battery then
   batwidget = awful.widget.progressbar()
   batwidget:set_width(8)
   batwidget:set_vertical(true)
   batwidget:set_background_color("#494B4F")
   batwidget:set_color("#000000")
   batwidget:set_gradient_colors({ "#CC0000", "#CC0000" })
   batwidget.widget:buttons(awful.util.table.join(
      awful.button({}, 1, function () awful.util.spawn("gnome-power-statistics") end)
   ))

   batwidget_t = awful.tooltip({ objects = { batwidget.widget },})
   vicious.register(batwidget, vicious.widgets.bat, function (widget, args)
       batwidget_t:set_text(
         "BAT0: " .. args[1] .. " (" .. args[2] .. ") " .. args[3] .. " left"
       )
      return args[2]
   end, 13, "BAT0")
end
-- }}}

-- {{{ clock
mytextclock = widget({ type = "textbox" })
vicious.register(mytextclock, vicious.widgets.date, "%a %b %e, %I:%M %P", 1)
cal.register(mytextclock, "<span color='lime'><u>%s</u></span>")

awful.widget.layout.margins[mytextclock] = { right = 5, left = 5 };
--}}}

-- {{{ cpu
cpuwidget = awful.widget.graph({ align = "right" })
cpuwidget:set_width(50)
cpuwidget:set_background_color("#000000")
cpuwidget:set_gradient_colors({ "#4E9A06", "#4E9A06" })
cpuwidget.widget:buttons(awful.util.table.join(
   awful.button({}, 1, function () awful.util.spawn("terminator -e glances") end)
))
cpuwidget_t = awful.tooltip({ objects = { cpuwidget.widget },})

vicious.register(cpuwidget, vicious.widgets.cpu,
  function (widget, args)
    local str = "Total " .. string.format("%03i", args[1])
    for i = 2, #args do
      str = str .. "\ncore " .. i - 1 .. " " .. string.format("%03i", args[i])
    end
    cpuwidget_t:set_text(str)
    return args[1]
end, 1)
-- }}}

-- {{{ temp
if has_thermal then
   tempwidget = awful.widget.graph({ align = "right" })
   tempwidget:set_width(50)
   tempwidget:set_background_color("#000000")
   tempwidget:set_gradient_colors({ "#C4A000", "#C4A000" })

   tempwidget_t = awful.tooltip({ objects = { tempwidget.widget },})
   vicious.register(tempwidget, vicious.widgets.thermal,
     function (widget, args)
       tempwidget_t:set_text("Temperature: " .. args[1] .. "°C")
       return args[1]
   end, 1, 'thermal_zone0')
end
-- }}}

-- {{{ memory
memorywidget = awful.widget.graph({ align = "right" })
memorywidget:set_width(50)
memorywidget:set_background_color("#000000")
memorywidget:set_gradient_colors({ "#3465A4", "#3465A4" })
memorywidget.widget:buttons(awful.util.table.join(
   awful.button({}, 1, function () awful.util.spawn("terminator -e glances") end)
))

memorywidget_t = awful.tooltip({ objects = { memorywidget.widget },})
vicious.register(memorywidget, vicious.widgets.mem,
  function (widget, args)
    memorywidget_t:set_text(" RAM: " .. args[2] .. "MB / " .. args[3] .. "MB ")
    return args[1]
end, 1)
-- }}}

-- {{{ weather
osweatherwidget = weather_widget(
   "KBIX", "http://forecast.io/#/f/30.4163,-88.8081/", "OS"
)

awful.widget.layout.margins[osweatherwidget] = { right = 5 };

smweatherwidget = weather_widget(
   "KSMO", "https://forecast.io/#/f/34.0189,-118.4962", "Santa Monica"
)

awful.widget.layout.margins[smweatherwidget] = { right = 5, left = 5 };

-- }}}

-- {{{ Create a systray
mysystray = widget({ type = "systray" })
--}}}

-- }}}

-- {{{ Wibox

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t)
                        local swap_t = awful.tag.selected()
                        local swap_s = t.screen
                        local sel = t.selected
                        if t.screen ~= mouse.screen then
                            sharetags.tag_move(t, mouse.screen)
                        end
                        if sel == true then
                            sharetags.tag_move(swap_t, swap_s)
                            awful.tag.viewonly(swap_t)
                        end
                        awful.tag.viewonly(t)
                    end),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, function(t)
                        if t.screen ~= mouse.screen then
                            sharetags.tag_move(t, mouse.screen)
                        end
                        awful.tag.viewtoggle(t)
                    end),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = sharetags.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)


    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        cpuwidget.widget,
        memorywidget.widget,
        osweatherwidget,
        smweatherwidget,
        has_battery and batwidget.widget or nil,
        has_thermal and tempwidget.widget or nil,
        volumecfg.widget.widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ }, "XF86ScreenSaver", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ }, "XF86AudioRaiseVolume", function () volumecfg.up() end),
    awful.key({ }, "XF86AudioLowerVolume", function () volumecfg.down() end),
    awful.key({ }, "XF86AudioMute", function () volumecfg.toggle() end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () awful.screen.focus(1) end),
    awful.key({ modkey, "Shift"   }, "w", function (c) awful.client.movetoscreen(c,1) end),
    awful.key({ modkey,           }, "e", function () awful.screen.focus(2) end),
    awful.key({ modkey, "Shift"   }, "e", function (c) awful.client.movetoscreen(c,2) end),
    awful.key({ modkey,           }, "p", function () awful.util.spawn("zsh -c 'source ~/.zshrc && xclip -o | nopaste -o'") end),
    awful.key({ modkey, "Shift"   }, "p", function () awful.util.spawn("zsh -c 'source ~/.zshrc && paste_edit'") end),
    awful.key({ modkey,           }, "Pause", function () awful.util.spawn("xdotool search 'play music' key space") end),

    -- Layout manipulation
    awful.key({ 'Mod4'            }, 'space', function() awful.util.spawn('qdbus org.mpris.MediaPlayer2.clementine /Player ShowOSD') end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

   awful.key({ modkey, "Shift"   }, "n",
       function()
           local tag = awful.tag.selected()
               for i=1, #tag:clients() do
                   tag:clients()[i].minimized=false
                   tag:clients()[i]:redraw()
           end
       end),
    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awful.util.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Shift"   }, "x",     function () awful.util.spawn('xscreensaver-command -lock') end),

    awful.key({ modkey },            "d",     function () awful.util.spawn('/home/frew/code/dotfiles/bin/showdm') end),

    awful.key({ modkey },            "u",     function () awful.util.spawn('/home/frew/code/dotfiles/bin/showuni') end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
keynumber = math.min(9, math.max(#tags, keynumber));

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local t = tags[i]
                        local swap_t = awful.tag.selected()
                        local swap_s = t.screen
                        local sel = t.selected
                        if t.screen ~= mouse.screen then
                            sharetags.tag_move(t, mouse.screen)
                        end
                        if sel == true then
                            sharetags.tag_move(swap_t, swap_s)
                            awful.tag.viewonly(swap_t)
                        end
                        awful.tag.viewonly(t)
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if tags[i] then
                          awful.tag.viewtoggle(tags[i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[i] then
                          awful.client.movetotag(tags[i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[i] then
                          awful.client.toggletag(tags[i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
 -- to get properties for these use xprop
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
        properties = { floating = true } },
    { rule = { class = "rdesktop" },
        properties = { fullscreen = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Handle client's borders
-- This handles beautiful's border_focus and border_normal and it removes
-- borders on fullscreen clients.

local pairs = pairs
local beautiful = require("beautiful")
local awful = {
   client = require("awful.client"),
   layout = require("awful.layout"),
   tag = require("awful.tag")
}
local capi = {
   client = client
}

module("borders")

-- {{{1 Border width

local function set_border(c, b)
   -- Ignore fullscreen windows, awful.ewmh handles those
   if c.fullscreen then return end
   c.border_width = b
end

function update_borders(c)
   -- Set suitable borders on windows:
   --  If there is only a single visible, full screen window, it doesn't
   --  get a border, everything else gets one.
   local screen = c.screen
   local theme = beautiful.get()
   local clients = awful.client.visible(screen)
   local tiledclients = awful.client.tiled(screen)
   local count = #tiledclients
   local layout = awful.layout.getname(awful.layout.get(screen))
   local border

   -- clients is tiledclients without all the floating clients, i.e. those
   -- clients are the clients managed by the current layout

   -- First: Floating clients always get a border
   for unused, current in pairs(clients) do
      if awful.client.floating.get(current) then
         set_border(current, theme.border_width)
      end
   end

   if (count == 1 and layout ~= "floating") or layout == "max" or layout == "fullscreen" then
      -- We aren't on a "floating" layout and the clients will be
      -- displayed fullscreen (either there is only one or this is a
      -- "max" layout which always does that).
      border = 0
   else
      -- Multiple visible, everyone gets a border
      border = theme.border_width
   end

   -- Second: All tiledclients get "border" as border
   for unused, current in pairs(tiledclients) do
      set_border(current, border)
   end
end

-- New tag selected, number of visible clients could change
awful.tag.attached_add_signal(nil, "property::selected", update_borders)

-- New layout selected, could be "max" layout
awful.tag.attached_add_signal(nil, "property::layout", update_borders)

capi.client.add_signal("new", function(c)
   -- Client tagged / untagged, number of visible clients could change
   c:add_signal("tagged", update_borders)
   c:add_signal("untagged", update_borders)

   -- Floating windows get a special border, so have to update
   c:add_signal("property::floating", update_borders)
end)

-- {{{1 Border color

capi.client.add_signal("manage", function(c)
   -- The tagged signal handled the border width, just need to handle color
   -- Some other manage signal could have messed with the border already!
   if capi.client.focus == c then
      c.border_color = beautiful.border_focus
   else
      c.border_color = beautiful.border_normal
   end
end)

capi.client.add_signal("focus", function (c)
   c.border_color = beautiful.border_focus
end)

capi.client.add_signal("unfocus", function (c)
   c.border_color = beautiful.border_normal
end)
-- vim: foldmethod=marker
