import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.Battery

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU
import System.Information.CPU2

main = do
  let
      memCallback = do
        mi <- parseMeminfo
        return [memoryUsedRatio mi]

      cpuCallback = do
        (userLoad, systemLoad, totalLoad) <- cpuLoad
        return [totalLoad, systemLoad]

      tempCallback = do
        ret <- getCPUTemp ["cpu0"]
        return [fromIntegral (ret!!0)]

      memCfg = defaultGraphConfig { graphDataColors = [(0, 0, 1, 1)]
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  }
      tempCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  }
      clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1
      pager = taffyPagerNew defaultPagerConfig
      note = notifyAreaNew defaultNotificationConfig
      wea = weatherNew (defaultWeatherConfig "KSMO") 10
      wea2 = weatherNew (defaultWeatherConfig "KBIX") 30
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      temp = pollingGraphNew tempCfg 1 tempCallback
      batt = batteryBarNew defaultBatteryConfig 1
      tray = systrayNew

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                        , endWidgets = [ tray, wea2, wea, clock, mem, cpu, batt, temp ]
                                        }
