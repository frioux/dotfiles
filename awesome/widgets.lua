local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")

local widgets = {}

function widgets.battery()
   local batwidget = wibox.widget.progressbar()
   batwidget:set_background_color("#494B4F")
   batwidget:set_color("#CC0000")
   batwidget:buttons(awful.util.table.join(
     awful.button({}, 1, function () awful.util.spawn("gnome-power-statistics") end)
   ))

   local batwidget_t = awful.tooltip({ objects = { batwidget },})
   vicious.register(batwidget, vicious.widgets.bat, function (widget, args)
     if args[1] == "+" then
         args[1] = "☇"
     end
     batwidget_t:set_text(
       "BAT0: " .. args[1] .. " (" .. args[2] .. ") " .. args[3] .. " left"
     )
     return args[2]
   end, 13, "BAT0")

   batwidget = wibox.container.rotate(batwidget, "east")
   batwidget = wibox.container.constraint(batwidget, "max", 16)

   return batwidget
end

function widgets.clock()
   local clock = wibox.widget.textclock()
   local cal = awful.widget.calendar_popup.month()
   cal:attach( clock, "tr" )

   return clock
end

function widgets.cpu()
   local cpu = wibox.widget.graph({ align = "right" })
   cpu:set_width(50)
   cpu:set_background_color("#000000")
   cpu:set_color("#4E9A06")
   cpu:buttons(awful.util.table.join(
     awful.button({}, 1, function () awful.util.spawn("terminator -e glances") end),
     awful.button({}, 3, function () awful.util.spawn("terminator -e top") end),
     awful.button({}, 2, function () awful.util.spawn("gnome-system-monitor") end)
   ))
   local tip = awful.tooltip({ objects = { cpu },})

   vicious.register(cpu, vicious.widgets.cpu,
     function (widget, args)
       local str = "Total " .. string.format("%03i", args[1])
       for i = 2, #args do
         str = str .. "\ncore " .. i - 1 .. " " .. string.format("%03i", args[i])
       end
       tip:set_text(str)
       return args[1]
    end, 1)

    return cpu
end

function widgets.temperature()
   local temperature = wibox.widget.graph({ align = "right" })
   temperature:set_width(50)
   temperature:set_background_color("#000000")
   temperature:set_color("#C4A000")

   local tip = awful.tooltip({ objects = { temperature },})
   vicious.register(temperature, vicious.widgets.thermal, function (widget, args)
     tip:set_text("Temperature: " .. args[1] .. "°C")
     return args[1]
   end, 1, 'thermal_zone0')
   temperature:buttons(awful.util.table.join(
     awful.button({ }, 1, function () awful.util.spawn("gnome-power-statistics") end),
     awful.button({ }, 3, function () awful.util.spawn("gksudo 'terminator -e powertop'") end)
))

    return temperature
end

function widgets.memory()
   local memory = wibox.widget.graph({ align = "right" })
   memory:set_width(50)
   memory:set_background_color("#000000")
   memory:set_color("#3465A4")
   memory:buttons(awful.util.table.join(
     awful.button({}, 1, function () awful.util.spawn("terminator -e glances") end),
     awful.button({}, 3, function () awful.util.spawn("terminator -e top") end),
     awful.button({}, 2, function () awful.util.spawn("gnome-system-monitor") end)
   ))

   local tip = awful.tooltip({ objects = { memory },})
   vicious.register(memory, vicious.widgets.mem,
     function (widget, args)
       tip:set_text(" RAM: " .. args[2] .. "MB / " .. args[3] .. "MB ")
       return args[1]
   end, 1)

   return memory
end

function widgets.weather(code, url, name)
  local weather = wibox.widget.textbox()
  local tip = awful.tooltip({ objects = { weather } });

  weather:buttons(awful.util.table.join(
    awful.button({}, 1, function () awful.spawn("firefox '" .. url .. os.time() .. "'") end)
  ))

  vicious.register(weather, vicious.widgets.weather,
    function (widget, args)
      tip:set_text(
        "City: " .. args["{city}"] ..
          "\nWind: " .. args["{windmph}"] .. "mph " ..
          "\nSky: " .. args["{sky}"] ..
          "\nHumidity: " .. args["{humid}"] ..
          "\nMeasured at: " .. os.date("%F %T", args["{when}"]))
      return name .. " " .. args["{tempf}"] .. "°F"
  end, 60 * 10, code)

  return weather
end

return widgets

-- vim: ts=4
