-- {{{ Imports
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- widget library
local vicious = require("vicious")

-- Local extensions
-- Menue functions
local freedesktop_menu = require("freedesktop.menu")
-- Modal keybindings
require("keychains")
-- Share tags on multiple screens
local sharetags = require("sharetags")
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal   = "urxvt"
editor     = os.getenv("EDITOR") or "vim"
home_dir   = os.getenv("HOME")
user       = os.getenv("USER")
conf_dir   = awful.util.getdir("config")
editor_cmd = terminal .. " -e " .. editor
wallpaper  = {
  home_dir .. "/Bilder/Icystones2.jpg",
  home_dir .. "/Bilder/Daisy.jpg",
  home_dir .. "/Bilder/Aqua.jpg",
  home_dir .. "/Bilder/InthedarkRedux.jpg",
  home_dir .. "/Bilder/RainDrops.jpg",
  home_dir .. "/Bilder/Maraetaibeforesunrise.jpg",
  home_dir .. "/Bilder/CurlsbyCandy.jpg",
  home_dir .. "/Bilder/Blinds.jpg",
  home_dir .. "/Bilder/Cornered.jpg"
}

-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
for s = 1, screen.count() do
    gears.wallpaper.maximized(wallpaper[s], s, true)
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
        names = { "main", "www", "office", "virtual", "eda", "cad", "screen", "media", 9 },
        layout = { layouts[2], layouts[4], layouts[1], layouts[2], layouts[12], 
                   layouts[4], layouts[11], layouts[2], layouts[1]  
        }}
tags = sharetags.create_tags(tags.names, tags.layout)
-- Set a greate mwfactor for www tag
awful.tag.setproperty(tags[2], "mwfact", 0.75)
-- }}}

-- {{{ Menu
-- Setup global menu keys
awful.menu.menu_keys.up    = { "k", "Up"}
awful.menu.menu_keys.down  = { "j", "Down"}
awful.menu.menu_keys.enter = { "l", "Right"}
awful.menu.menu_keys.back  = { "h", "Left"}

-- Create a laucher widget and a main menu
myawesomemenu = awful.menu({ items = {
   { "awesome", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "xdg", editor_cmd .. " " .. home_dir .. "/.config/" },
   { "vim", editor_cmd .. " " .. ".vimrc" },
   { "Xdefaults", editor_cmd .. " " .. ".Xdefaults" },
   -- TODO do with naughty
   --{ "Xprop", terminal .. " -e xprop | grep --color=none 'WM_CLASS\|^WM_NAME' | less " }
   }
})

myappmenu = awful.menu({ items = freedesktop_menu.new() }) 
mymainmenu = awful.menu({ items = { { "luakit", "luakit"},
                                    { "ranger", terminal .. " -e ranger"},
                                    { "Neustarten", "sudo shutdown -r now" },
                                    { "Ausschalten",  "sudo shutdown -h now" }
                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()
 
-- {{{ Reusable separator
separator = wibox.widget.imagebox()
separator:set_image(conf_dir .. "/icons/separator.png")
-- }}}

-- {{{ Volume level
volicon = wibox.widget.imagebox()
volicon:set_image(conf_dir .. "/icons/vol.png")
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = wibox.widget.textbox()
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color("#494B4F")
--volbar:set_gradient_colors({ "#AECF96",
--   "#88A175", "#FF5656"
--}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master")
-- Register buttons
volbar:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e alsamixer") end),
   awful.button({ }, 4, function () awful.util.spawn("amixer -q set Master 2dB+", false) end),
   awful.button({ }, 5, function () awful.util.spawn("amixer -q set Master 2dB-", false) end)
)) -- Register assigned buttons
volwidget:buttons(volbar:buttons())
-- }}}

-- {{{ Battery state
baticon = wibox.widget.imagebox()
baticon:set_image(conf_dir .. "/icons/bat.png")
-- Initialize widget
batwidget = wibox.widget.textbox()
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT1")
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    --mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mytaglist[s] = sharetags.taglist_new(s, sharetags.filter_all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(volicon)
--    right_layout:add(volbar.widget)
    right_layout:add(volwidget)
    right_layout:add(separator)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(separator)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    -- windowmovements like in vim
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.bydirection( "down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.bydirection( "up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.bydirection( "right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.bydirection( "left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.bydirection( "down")    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.bydirection( "up")      end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.bydirection( "left")    end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.bydirection( "right")   end),

    -- Open Menus
    awful.key({ modkey,           }, "space", function () mymainmenu:show({keygrabber = true})        end),
    awful.key({ }, "XF86Launch1", function () myawesomemenu:show({keygrabber = true})        end),

    -- Layout manipulation
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,  "Shift"  }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "Return", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    -- Wichtige Programme starten
    awful.key({ modkey,           }, "v", function () awful.util.spawn(editor_cmd) end),
    awful.key({ modkey,           }, "t", function () awful.util.spawn(terminal .. " -e tmux") end),

    -- Bildschirm sperren
    awful.key({ modkey,           }, "w", function () awful.util.spawn("xscreensaver-command -lock") end),

    -- Präsentationsmodus umschalten mit Fn-F7
    awful.key({ }, "XF86Display", function () awful.util.spawn("~/bin/toggle-display --toggle") end),
    -- Bluetooth umschalten mit Fn-F5
    awful.key({ modkey, }, "F5", function () awful.util.spawn("~/bin/toggle-bluetooth") end),

    -- Keybindings fuer die Lautstaerkeregelung
    awful.key({"Shift",           }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q set PCM 1+ unmute") end),
    awful.key({"Shift",           }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q set PCM 1- unmute") end),
    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q set Master 1+ unmute") end),
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q set Master 1- unmute") end),
    awful.key({                   }, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    --awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
--keynumber = math.min(9, math.max(#tags, keynumber));
keynumber = 9

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
keychains.init(globalkeys,
  {
    notify = {
      bg="#000000",
      position="bottom_left",
      icon_size=32
    },
    menu = {
      bg_normal = "#44444499",
      bg_focus  = "#002288cc",
      fg_normal = "#ffffff",
      fg_focus  = "#ffff00",
      border_color = "#111111",
      border_width = 2
    }
  })

-- add keychain bindings
keychains.add( { modkey }, "x", "utils", "", {
  -- Menue anzeigen
  space = {
    func = function () myappmenu:show({keygrabber = true}) end,
    info = "Applications Menu"
  },
  m = {
    func = function () myappmenu:show({keygrabber = true}) end,
    info = "Applications Menu"
  },
  r = {
    func = function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
          mypromptbox[mouse.screen].widget,
          awful.util.eval, nil,
          awful.util.getdir("cache") .. "/history_eval")
        end,
    info = "Run Lua code"
  }
})

keychains.start()
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
                   } },
    { rule_any = { class = {"MPlayer", "pinentry", "Gimp", "recordMyDesktop",
                        "Skype", "Vlc", "Arandr", } },
      properties = { floating = true } },
    -- VirtualBox immer auf dem 4. tag platzieren
    { rule_any = { class = {"VirtualBox", "rdesktop", "nxclient",
                        "NX.[%a%d_-]*", "Gvncviewer", "vinagre", } },
      properties = { tag = tags[4]} },
    -- PCB immer auf dem 5. tag platzieren
    { rule_any = { class = {"Pcb", "PCB"} },
      properties = { tag = tags[5]} },
    -- Place Freecad always on tag "cad"
    { rule = { class = "Freecad" },
      properties = { tag = tags[6]} },
    -- Set Firefox to always map on tags number 2
    { rule_any = { class = {"Chromium", "luakit", "Zathura"} },
      properties = { tag = tags[2] } },
    -- Place incskape always on tag "media"
    { rule = { class = "Inkscape" },
      properties = { tag = tags[8] } },
    -- Place all libreoffice windows on tag "office"
    { rule = { class = "libreoffice[%a%d_-]*" },
      properties = { tag = tags[3] } },
    { rule = { class = "[Ss]office" },
      properties = { tag = tags[3] } },
    -- Place anki always on tag "office" and make it floating
    { rule = { class = "Anki" },
      properties = { tag = tags[3], floating = true } },
    -- Start urxvt always as slave
    { rule_any = { class = {"URxvt", "XTerm"} },
      properties = { }, callback = awful.client.setslave },
    { rule = { class = "Screenkey" },
      properties = { floating = true, skip_taskbar = true, focusable = false, opacity = 0.5 } },
    -- enable browser video plugin fullscreen
    { rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart
-- Maus-Einstellungen
os.execute("~/bin/mouse-settings &")

-- Applets
os.execute("ps -U " .. user .. " | grep wicd-client >/dev/null || wicd-gtk --tray &")
os.execute("ps -U " .. user .. " | grep blueman-applet >/dev/null || ( sleep 2; blueman-applet ) &")

-- Bildschirmschoner und Powermanagement
os.execute("xscreensaver &")
--awful.util.spawn(editor_cmd .. " " .. home_dir .. "/welcome.txt")
-- }}}

-- vim: fdm=marker:
