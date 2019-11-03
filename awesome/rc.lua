-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local vicious = require("vicious")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local charitable = require("charitable")
local os = require("os")

awful.tag.history.restore = function() end

local vol = require("volume")

local widgets = require("widgets")

local capi = { screen = screen }
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
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

local DEBUGGING = os.getenv("DISPLAY") ~= ":0"

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.font = "terminus 20"
beautiful.hotkeys_font = "terminus 20"
beautiful.hotkeys_description_font = "terminus 20"
beautiful.menu_width = 200
beautiful.menu_height = 24

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
if DEBUGGING then
   modkey = "Mod1"
end

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.max,
}

local parallel_layouts = {
   [awful.layout.suit.tile] = awful.layout.suit.tile.left,
   [awful.layout.suit.tile.left] = awful.layout.suit.tile,

   [awful.layout.suit.tile.bottom] = awful.layout.suit.tile.top,
   [awful.layout.suit.tile.top] = awful.layout.suit.tile.bottom,

   [awful.layout.suit.max] = awful.layout.suit.max.fullscreen,
   [awful.layout.suit.max.fullscreen] = awful.layout.suit.max,
}

local function swap_layout ()
   local t = awful.screen.focused().selected_tag
   local l = t.layout
   awful.layout.set(parallel_layouts[l])
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

mymainmenu = awful.menu({
    items = {
              menu_awesome,
              menu_terminal,
            }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- }}}

-- {{{ Wibar

local volumecfg = vol.new()
local batwidget = widgets.battery()
local cpuwidget = widgets.cpu()
local tempwidget = widgets.temperature()
local memorywidget = widgets.memory()

local function margin(widget, margins)
  local margin = wibox.container.margin()
  if margins.right then
    margin:set_right(margins.right)
  end
  if margins.left then
    margin:set_left(margins.left)
  end
  margin:set_widget(widget)
  return wibox.container.background(margin)
end

local aqi = widgets.aqi("Northwest Coastal LA County")
aqi = margin(aqi, { right = 5 })

local osweatherwidget = widgets.weather(
  "KGPT", "https://darksky.net/30.4113,-88.8279", "OS"
)

osweatherwidget = margin(osweatherwidget, { right = 5 })

local smweatherwidget = widgets.weather(
  "KSMO", "https://darksky.net/34.0196,-118.487", "Santa Monica"
)

smweatherwidget = margin(smweatherwidget, { left = 5, right = 5 })

-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) charitable.select_tag(t, awful.screen.focused()) end),

    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    awful.button({ }, 3, function(t) charitable.toggle_tag(t, awful.screen.focused()) end),

    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),

    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tags = charitable.create_tags(
   { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
   {
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.suit.max,
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
      awful.layout.layouts[1],
   }
)

awful.screen.connect_for_each_screen(function(s)
    for i = 1, #tags do
         if not tags[i].selected then
             tags[i].screen = s
             tags[i]:view_only()
             break
         end
    end


    s.scratch = awful.tag.add('scratch-' .. s.index, {})

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
       screen = s,
       filter = awful.widget.taglist.filter.noempty,
       buttons = taglist_buttons,
       source = function(screen, args) return tags end,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32 })

    s.mytextclock = widgets.clock(s)

    -- Add widgets to the wibox
    local right = {
        layout = wibox.layout.fixed.horizontal(right),
        spacing = 2,
        wibox.widget.systray(),
        tempwidget,
        batwidget,
        memorywidget,
        cpuwidget,
        smweatherwidget,
        osweatherwidget,
        volumecfg.widget,
        s.mytextclock,
        aqi,
        s.mylayoutbox,
    }
    if DEBUGGING then
        table.remove(right, 2) -- temp
        table.remove(right, 2) -- bat
        table.remove(right, 2) -- memory
        table.remove(right, 2) -- cpu
        table.remove(right, 2) -- smweather
        table.remove(right, 2) -- osweather
        table.remove(right, 2) -- vol
    end
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
        },
        nil,
        right,
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey }, "c",
              function ()
                 awful.screen.focused().mytextclock._cal:toggle()
              end,
              {description = "toggle calendar", group = "awesome"}),

    awful.key({ modkey,           }, "j",
        function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey,           }, "q", function () awful.screen.focus(2) end,
              {description = "focus screen 1", group = "screen"}),
    awful.key({ modkey,           }, "w", function () awful.screen.focus(1) end,
              {description = "focus screen 2", group = "screen"}),
    awful.key({ modkey,           }, "e", function () awful.screen.focus(3) end,
              {description = "focus screen 3", group = "screen"}),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey }, "b", function () mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible end,
              { description = "toggle wibox", group = "awesome"}),
    awful.key({ modkey,           }, "b", awful.titlebar.toggle),
    awful.key({ modkey,           }, "d", function () awful.spawn("showdm") end,
              {description = "showdm", group = "launcher"}),
    awful.key({ modkey,           }, "n", function () awful.spawn("terminator -e 'vim -S /home/frew/.vvar/sessions/wnotes' -T 'vim:/home/frew/.vvar/sessions/wnotes'") end,
              {description = "notes", group = "launcher"}),
    awful.key({ modkey,           }, "u", function () awful.spawn("showuni") end,
              {description = "showuni", group = "launcher"}),
    awful.key({ modkey,           }, "v", function () awful.spawn("showsession") end,
              {description = "showsession", group = "launcher"}),
    awful.key({ modkey,           }, "x", function () awful.spawn("lock-now") end,
              {description = "lock-now", group = "launcher"}),
    awful.key({ }, "XF86AudioMute", volumecfg.toggle),
    awful.key({ }, "XF86AudioLowerVolume", volumecfg.down),
    awful.key({ }, "XF86AudioRaiseVolume", volumecfg.up),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("backlight -10") end),
    awful.key({ }, "XF86MonBrightnessUp",   function () awful.spawn("backlight  10") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
    awful.key({ modkey,           }, "z", swap_layout, {description = "toggle layout", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
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

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

    {
       rule = { class = "Firefox"  },
       properties = {
           tag = "2",
           keys = awful.util.table.join(
               clientkeys,
               awful.key({ 'Control' }, 'q', function() end)
           )
       },
    },
    { rule = { class = "keepassxc" }, properties = { tag = "8" } },
    { rule = { class = "Signal"    }, properties = { tag = "9" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.disconnect_signal("request::activate", awful.ewmh.activate)
function awful.ewmh.activate(c)
    if c:isvisible() then
        client.focus = c
        c:raise()
    end
end
client.connect_signal("request::activate", awful.ewmh.activate)

tag.connect_signal("request::screen", function(t)
    t.selected = false
    for s in capi.screen do
        if s ~= t.screen then
            t.screen = s
            return
        end
    end
end)

screen.connect_signal("arrange", function(s)
    local layout_name = awful.layout.get(s).name
    for _, c in pairs(s.clients) do
        if (#s.tiled_clients == 1 and c.floating == false) or layout_name == "max" or layout_name == "fullscreen" then
            c.border_width = 0
        elseif #s.tiled_clients > 1 then
            c.border_width = beautiful.border_width
        end
    end
end)

client.connect_signal("property::minimized", function(c)
    c.minimized = false
end)
-- }}}

-- vim: foldmethod=marker
