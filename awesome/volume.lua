local awful = require("awful")
local wibox = require("wibox")

local volume = {}

function volume.new()
   local volumecfg = {}
   local chart = wibox.widget.progressbar()
   chart:set_max_value(100)
   chart:set_color('#FFFFFF')

   local rendered_chart = chart
   rendered_chart = wibox.container.rotate(rendered_chart, "east")
   rendered_chart = wibox.container.constraint(rendered_chart, "max", 16)

   local text = wibox.widget.textbox()

   local composite = wibox.widget({
      rendered_chart,
      text,
      layout = wibox.layout.fixed.horizontal,
      forced_width = 70,
      spacing = 2,
   })

   volumecfg.widget = composite

   local tip = awful.tooltip({ objects = { volumecfg.widget.widget },})

   volumecfg.mixercommand = function (command)
     local fd = io.popen("vol " .. command)
     local status = fd:read("*all")
     fd:close()

     local volume = string.match(status, "volume: (%d+)") or 0
     volume = string.format("% 3d", volume)
     text:set_text(volume)
     status = string.match(status, "muted: (%d)") or ''
     chart:set_value(tonumber(volume))
     if status == "0" then
       chart:set_color('#FFFFFF')
       tip:set_text("Volume: " .. volume .. '%')
     else
       chart:set_color('#FF0000')
       tip:set_text("Volume: " .. volume .. '%, muted')
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
     awful.button({ }, 3, function () awful.util.spawn("pavucontrol") end)
   ))
   volumecfg.update()

   return volumecfg
end

return volume
