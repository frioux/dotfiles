local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")
local gears = require("gears")

local calendar_popup = require("gross.calendar_popup")

local widgets = {}

function widgets.editable(w)
  local i = debug.getinfo(2, "Sl")
  assert(string.sub(i.source, 1, 1) == "@", "source is not a filename")

  local realpath = string.sub(i.source, 2) -- strip @ prefix
  w:buttons(awful.util.table.join(
    w:buttons(),
    awful.button({ modkey }, 1, function ()
      awful.util.spawn("terminator -e 'vim " .. realpath .. " +" .. tostring(i.currentline) .. "'")
    end)
  ))

  return w
end

function widgets.aqi()
  local aqi = wibox.widget.textbox()
  local tip = awful.tooltip({ objects = { aqi } });

  aqi:buttons(awful.util.table.join(
    awful.button({}, 3, function () awful.spawn("firefox https://www.latimes.com/wildfires-map/") end),
    awful.button({}, 1, function(w) vicious.force(w) end)
  ))

  vicious.register(aqi, vicious.widgets.aqi,
    function (widget, args)
       tip:set_text(
         "Measured at: " .. os.date("%F %T", tonumber(args["{measured_at}"])/1000) ..
          "\nRequested at: " .. os.date("%F %T")
       )

       return "AQI " .. args["{aqi}"]
    end,
  30 * 60, 'Northwest Coastal LA County')

  widgets.editable(aqi)
  return aqi
end

function widgets.battery()
   local chart = wibox.widget.progressbar()
   chart:set_background_color("#494B4F")
   chart:set_color("#CC0000")

   local rendered_chart = chart
   rendered_chart = wibox.container.rotate(rendered_chart, "east")
   rendered_chart = wibox.container.constraint(rendered_chart, "exact", 16)


   local text = wibox.widget.textbox()

   local composite = wibox.widget({
      rendered_chart,
      text,
      layout = wibox.layout.fixed.horizontal,
      forced_width = 75,
      spacing = 2,
   })
   composite:buttons(awful.util.table.join(
     awful.button({}, 3, function () awful.util.spawn("gnome-power-statistics") end)
   ))
   local tip = awful.tooltip({ objects = { composite },})

   vicious.register(chart, vicious.widgets.bat, function (widget, args)
     if args[1] == "+" then
         args[1] = "☇"
     end
     tip:set_text(
       "BAT0: " .. args[1] .. " (" .. args[2] .. ") " .. args[3] .. " left"
     )
     text:set_text(args[2] .. "%")
     return args[2]
   end, 13, "BAT0")

   widgets.editable(composite)
   return composite
end

function widgets.clock(screen)
   local widget = wibox.widget.textclock()
   local self = calendar_popup.month({
      screen = screen,
      bg = "#111111",
   })
   widget._cal = self

   -- inlined from calendar_popup:attach
   local position = "tr"
   local args = args or {}
   if args.on_hover == nil then args.on_hover=true end
   widget:buttons(gears.table.join(
       awful.button({ }, 1, function ()
                             if not self.visible or self._calendar_clicked_on then
                                 self:call_calendar(0, position)
                                 self.visible = not self.visible
                             end
                             self._calendar_clicked_on = self.visible
                       end),
       awful.button({ }, 3, function ()
           awful.util.spawn("firefox https://calendar.google.com/calendar/b/0/r/week")
       end),
       awful.button({ }, 4, function () self:call_calendar(-1) end),
       awful.button({ }, 5, function () self:call_calendar( 1) end)
   ))
   if args.on_hover then
       widget:connect_signal("mouse::enter", function ()
           if not self._calendar_clicked_on then
               self:call_calendar(0, position)
               self.visible = true
           end
       end)
       widget:connect_signal("mouse::leave", function ()
           if not self._calendar_clicked_on then
               self.visible = false
           end
       end)
   end

   widgets.editable(widget)
   return widget
end

function widgets.cpu()
   local cpu = wibox.widget.graph({ align = "right" })
   cpu:set_width(50)
   cpu:set_background_color("#000000")
   cpu:set_color("#4E9A06")
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

   widgets.editable(cpu)
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

   widgets.editable(temperature)
   return temperature
end

function widgets.memory()
   local memory = wibox.widget.graph({ align = "right" })
   memory:set_width(50)
   memory:set_background_color("#000000")
   memory:set_color("#3465A4")

   local tip = awful.tooltip({ objects = { memory },})
   vicious.register(memory, vicious.widgets.mem,
     function (widget, args)
       tip:set_text(" RAM: " .. args[2] .. "MB / " .. args[3] .. "MB ")
       return args[1]
   end, 1)

   widgets.editable(memory)
   return memory
end

function widgets.weather(code, url, name)
  local weather = wibox.widget.textbox()
  local tip = awful.tooltip({ objects = { weather } });

  weather:buttons(awful.util.table.join(
    awful.button({}, 3, function () awful.spawn("firefox '" .. url .. os.time() .. "'") end),
    awful.button({}, 1, function(w) vicious.force(w) end)
  ))

  vicious.register(weather, vicious.widgets.weather,
    function (widget, args)
      -- make "N/A" not break vicious
      if type(args["{when}"]) == "string" then
         args["{when}"] = 0
      end
      tip:set_text(
        "City: " .. args["{city}"] ..
          "\nWind: " .. args["{windmph}"] .. "mph " ..
          "\nSky: " .. args["{sky}"] ..
          "\nHumidity: " .. args["{humid}"] ..
          "\n Measured at: " .. os.date("%F %T", args["{when}"]) ..
          "\nRequested at: " .. os.date("%F %T"))
      return name .. " " .. args["{tempf}"] .. "°F"
  end, 60 * 10, code)

   widgets.editable(weather)
   return weather
end

return widgets

-- vim: ts=4
