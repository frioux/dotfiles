import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.Battery

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import Control.Monad.IO.Class
import XMonad.Util.Run
import System.Information.Memory
import System.Information.CPU
import System.Information.CPU2
import qualified Graphics.UI.Gtk as Gtk

main = do
  let
      memCallback :: IO [Double]
      memCallback = do
        mi <- parseMeminfo
        return [memoryUsedRatio mi]

      cpuCallback :: IO [Double]
      cpuCallback = do
        (userLoad, systemLoad, totalLoad) <- cpuLoad
        return [totalLoad, systemLoad]

      tempCallback :: IO [Double]
      tempCallback = do
        ret <- getCPUTemp ["cpu0"]
        return [fromIntegral (ret!!0)]

      memCfg :: GraphConfig
      memCfg = defaultGraphConfig { graphDataColors = [(0, 0, 1, 1)]
                                  }
      cpuCfg :: GraphConfig
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  }
      tempCfg :: GraphConfig
      tempCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  }

      clock :: IO Gtk.Widget
      clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %_d %H:%M</span>" 1

      pager :: IO Gtk.Widget
      pager = taffyPagerNew defaultPagerConfig

      note :: IO Gtk.Widget
      note = notifyAreaNew defaultNotificationConfig

      mem :: IO Gtk.Widget
      mem = do btn <- pollingGraphNew memCfg 1 memCallback
               ebox <- Gtk.eventBoxNew
               Gtk.containerAdd ebox btn
               _ <- Gtk.on ebox Gtk.buttonPressEvent systemCallback
               Gtk.widgetShowAll ebox
               return $ Gtk.toWidget ebox


      systemCallback :: Gtk.EventM Gtk.EButton Bool
      systemCallback = do
        e <- Gtk.eventButton
        case e of
          Gtk.LeftButton   -> unsafeSpawn "terminator -e glances"
          Gtk.RightButton  -> unsafeSpawn "terminator -e top"
          Gtk.MiddleButton -> unsafeSpawn "gnome-system-monitor"
          _ -> return ()
        return True

      cpu :: IO Gtk.Widget
      cpu = do btn <- pollingGraphNew cpuCfg 0.5 cpuCallback
               ebox <- Gtk.eventBoxNew
               Gtk.containerAdd ebox btn
               _ <- Gtk.on ebox Gtk.buttonPressEvent systemCallback
               Gtk.widgetShowAll ebox
               return $ Gtk.toWidget ebox


      tempCallback1 :: Gtk.EventM Gtk.EButton Bool
      tempCallback1 = do
        e <- Gtk.eventButton
        case e of
          Gtk.LeftButton  -> unsafeSpawn "gnome-power-statistics"
          Gtk.RightButton -> unsafeSpawn "terminator -e 'sudo powertop'"
          _ -> return ()
        return True

      temp :: IO Gtk.Widget
      temp = do btn <- pollingGraphNew tempCfg 1 tempCallback
                ebox <- Gtk.eventBoxNew
                Gtk.containerAdd ebox btn
                _ <- Gtk.on ebox Gtk.buttonPressEvent tempCallback1
                Gtk.widgetShowAll ebox
                return $ Gtk.toWidget ebox

      battCallback :: Gtk.EventM Gtk.EButton Bool
      battCallback = do
        unsafeSpawn "gnome-power-statistics"
        return True

      batt :: IO Gtk.Widget
      batt = do btn <- batteryBarNew defaultBatteryConfig 1
                ebox <- Gtk.eventBoxNew
                Gtk.containerAdd ebox btn
                _ <- Gtk.on ebox Gtk.buttonPressEvent battCallback
                Gtk.widgetShowAll ebox
                return $ Gtk.toWidget ebox

      tray :: IO Gtk.Widget
      tray = systrayNew

      weaCallback :: Gtk.EventM Gtk.EButton Bool
      weaCallback = do
        unsafeSpawn "firefox https://darksky.net/34.0196,-118.487"
        return True

      wea :: IO Gtk.Widget
      wea = do btn <- weatherNew (defaultWeatherConfig "KSMO") { weatherTemplate = "SM $tempF$ °C" } 10
               ebox <- Gtk.eventBoxNew
               Gtk.containerAdd ebox btn
               _ <- Gtk.on ebox Gtk.buttonPressEvent weaCallback
               Gtk.widgetShowAll ebox
               return $ Gtk.toWidget ebox

      wea2Callback :: Gtk.EventM Gtk.EButton Bool
      wea2Callback = do
        unsafeSpawn "firefox https://darksky.net/30.4113,-88.8279"
        return True

      wea2 :: IO Gtk.Widget
      wea2 = do btn <- weatherNew (defaultWeatherConfig "KBIX") { weatherTemplate = "OS $tempF$ °C" } 30
                ebox <- Gtk.eventBoxNew
                Gtk.containerAdd ebox btn
                _ <- Gtk.on ebox Gtk.buttonPressEvent wea2Callback
                Gtk.widgetShowAll ebox
                return $ Gtk.toWidget ebox

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                        , endWidgets = [ tray, wea2, wea, clock, mem, cpu, batt, temp ]
                                        }
