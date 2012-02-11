-- {{{ Imports
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- widget library
require("vicious")

-- Local extensions
-- Menue functions
local freedesktop_menu = require("freedesktop.menu")
-- Modal keybindings
require("modal")
-- Share tags on multiple screens
require("sharetags")
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal   = "urxvt"
editor     = os.getenv("EDITOR") or "vim"
home_dir   = os.getenv("HOME")
user       = os.getenv("USER")
editor_cmd = terminal .. " -e " .. editor
browser    = "uzbl-browser"

-- Themes define colours, icons, and wallpapers
beautiful.init(home_dir .. "/.config/awesome/zenburn.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
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
-- Create a laucher widget and a main menu
myawesomemenu = awful.menu({ items = {
   { "awesome", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "xdg", editor_cmd .. " " .. home_dir .. "/.config/" },
   { "vim", editor_cmd .. " " .. ".vimrc" },
   { "Xdefaults", editor_cmd .. " " .. ".Xdefaults" }
   }
})

myappmenu = awful.menu({ items = freedesktop_menu.new() }) 
mymainmenu = awful.menu({ items = { { "luakit", "luakit"},
                                    { "ranger", terminal .. " -e ranger"},
                                    { "Neustarten", "sudo shutdown -r now" },
                                    { "Ausschalten",  "sudo shutdown -h now" }
                                  }
                        })

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
 
-- Create a systray
mysystray = widget({ type = "systray" })

-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(12):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e alsamixer") end),
   awful.button({ }, 4, function () awful.util.spawn("amixer -q set Master 2dB+", false) end),
   awful.button({ }, 5, function () awful.util.spawn("amixer -q set Master 2dB-", false) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())
-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT1")
-- }}}

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t)
                        if t.screen ~= mouse.screen then
                            sharetags.tag_move(t, mouse.screen)
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
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
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
    --mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
    mytaglist[s] = sharetags.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

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
        s == 1 and mysystray or nil,
        separator, volwidget,  volbar.widget, volicon,
        separator, batwidget, baticon,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
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

    -- Keychains anlegen
    awful.key({ modkey,           }, "x", function (c) 
        modal.modal_push( {
            -- Menue anzeigen
            space = function () 
                myappmenu:show({keygrabber = true}) 
            end,

            r = function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                    mypromptbox[mouse.screen].widget,
                    awful.util.eval, nil,
                    awful.util.getdir("cache") .. "/history_eval")
                    end,
        })
    end),

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
keynumber = 0
keynumber = math.min(9, math.max(#tags, keynumber));

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        sharetags.tag_to_screen(tags[i], screen)
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
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                   } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "recordMyDesktop" },
      properties = { floating = true } },
    -- Multimediaprogramme ihre Groesse und Form immer selbst bestimmen lassen
    { rule = { class = "Skype" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    -- VirtualBox immer auf dem 4. tag platzieren
    { rule = { class = "VirtualBox" },
      properties = { tag = tags[4]} },
    -- PCB immer auf dem 5. tag platzieren
    { rule = { class = "Pcb" },
      properties = { tag = tags[5]} },
    { rule = { class = "PCB" },
      properties = { tag = tags[5]} },
    -- Place Freecad always on tag "cad"
    { rule = { class = "Freecad" },
      properties = { tag = tags[6]} },
    -- Set Firefox to always map on tags number 2
    { rule = { class = "Chromium" },
      properties = { tag = tags[2] } },
    { rule = { class = "Zathura" },
      properties = { tag = tags[2] } },
    { rule = { class = "luakit" },
      properties = { tag = tags[2] } },
    -- Place incskape always on tag "media"
    { rule = { class = "Inkscape" },
      properties = { tag = tags[8] } },
    -- Start urxvt always as slave
    { rule = { class = "URxvt" },
      properties = { }, callback = awful.client.setslave },
}
--shifty.config.apps = {
--    { match = { "Uzbl", "Chromium", "zathura", "luakit"}, tag = "2:www"},
--    { match = { "xterm", "urxvt"}, slave = True },
--    { match = { "htop", "Wicd", "alsamixer", "zenmap", "Pavucontrol",
--                    "Blueman-manager"}, tag = "3:sys"},
--    { match = { "MPlayer", "feh", "Xfburn", "Skype"},
--                    float = true, tag = "8:media"},
--    { match = { "recordMyDesktop", "screenkey"}, float = true},
--    { match = { "VirtualBox", "rdesktop", "nxclient", "NX.*", "Gvncviewer",
--                    "vinagre"}, tag = "4:virtual"},
--    { match = { "Freecad"}, tag = "5:cad"},
--    { match = { "" }, buttons = {
--        button({ }, 1, function (c) client.focus = c; c:raise() end),
--        button({ modkey }, 1, function (c) awful.mouse.client.move() end),
--        button({ modkey }, 3, function (c) awful.mouse.client.resize() end),
--        },
--    },
--}
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
