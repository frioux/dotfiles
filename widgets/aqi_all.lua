-- {{{ Grab environment
-- local success, json = pcall(require, "cjson")
-- if not success then
--   json = require("json")
-- end

-- local spawn = require"vicious.spawn"
-- local helpers = require"vicious.helpers"
-- -- }}}


-- -- AQI: provides AQI information for a requested location
-- -- vicious.widgets.aqi
-- local aqi_all = {}

-- -- {{{ AQI widget type
-- local function parse(stdout, stderr, exitreason, exitcode)
--     -- Initialize function tables
--     local _aqi = {
--         ["{aqi}"] = "N/A",
--         ["{when}"] = "N/A",
--         ["{description}"] = "N/A",
--         ["{name}"] = "N/A",
--     }

--     -- Check if there was a timeout or a problem with the station
--     if stdout == '' then return _aqi end

--     local status, data = pcall(function() return json.decode(response) end)
--     if not status or not data then
--         return _aqi
--     end

--     data = data.features[0].attributes
--     _aqi["{aqi}"] = data["aqi"]
--     _aqi["{name}"] = data["name"]
--     _aqi["{description}"] = data["pollutant_desc"]
--     -- _aqi["{aqi}"] = data["aqi"]

--     return _aqi
-- end

function aqi_all.async(format, warg, callback)
    if not warg then return callback{} end

    local url = "https://services2.arcgis.com/I4NVzmfP3kyPvlVg/arcgis/rest/services/HourlyAQI_prod/FeatureServer/0/query?where=name%3D%22" ..
      warg:gsub(" ", "%20") ..
      "%22&outFields=aqi,current_datetime,pollutant_desc,name&outSR=4326&f=json"

    spawn.easy_async("curl -fs " .. url,
                     function (...) callback(parse(...)) end)
end
-- }}}

return helpers.setasyncall(aqi_all)
