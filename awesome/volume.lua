local awful = require("awful")
local wibox = require("wibox")

local volume = {}

function volume.new()
   local volumecfg = {}
   volumecfg._widget = wibox.widget.progressbar()
   volumecfg._widget:set_max_value(100)
   volumecfg._widget:set_color('#FFFFFF')

   volumecfg.widget = volumecfg._widget
   volumecfg.widget = wibox.container.rotate(volumecfg.widget, "east")
   volumecfg.widget = wibox.container.constraint(volumecfg.widget, "max", 16)

   local volumecfg_t = awful.tooltip({ objects = { volumecfg.widget.widget },})

   volumecfg.mixercommand = function (command)
     local fd = io.popen("vol " .. command)
     local status = fd:read("*all")
     fd:close()

     local volume = string.match(status, "volume: (%d+)") or 0
     volume = string.format("% 3d", volume)
     status = string.match(status, "muted: (%d)") or ''
     volumecfg._widget:set_value(tonumber(volume))
     if status == "0" then
       volumecfg._widget:set_color('#FFFFFF')
       volumecfg_t:set_text("Volume: " .. volume .. '%')
     else
       volumecfg._widget:set_color('#FF0000')
       volumecfg_t:set_text("Volume: " .. volume .. '%, muted')
     end
   end

   volumecfg.update = function () volumecfg.mixercommand("status") end
   volumecfg.up     = function () volumecfg.mixercommand("up")     end
   volumecfg.down   = function () volumecfg.mixercommand("down")   end
   volumecfg.toggle = function () volumecfg.mixercommand("toggle") end

   volumecfg.widget:buttons(awful.util.table.join(
     awful.button({ }, 4, function () volumecfg.up() end),
     awful.button({ }, 5, function () volumecfg.down() end),
     awful.button({ }, 1, function () volumecfg.toggle() end),
     awful.button({ }, 3, function () awful.util.spawn("terminator -e alsamixer") end),
     awful.button({ }, 2, function () awful.util.spawn("pavucontrol") end)
   ))
   volumecfg.update()

   return volumecfg
end

return volume
