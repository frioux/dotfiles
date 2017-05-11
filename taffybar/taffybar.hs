import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.Battery

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import XMonad.Util.Run
import System.Information.Memory
import System.Information.CPU
import System.Information.CPU2
import Text.Show
import Text.Printf
import qualified Graphics.UI.Gtk as Gtk

main = do
  let
      memReader :: Gtk.Widget -> IO [Double]
      memReader widget = do
        mi <- parseMeminfo
        Gtk.postGUIAsync $ do
          let
            used    = round $ memoryUsed   mi :: Int
            total   = round $ memoryTotal  mi :: Int
            cached  = round $ memoryCache  mi :: Int
            buffers = round $ memoryBuffer mi :: Int
            ratio   = round $ 100 * memoryUsedRatio mi :: Int
            tooltip = printf "%imB Used / %imB Total (%i%%)\nCached: %imB\nBuffers: %imB" used total ratio cached buffers :: String
          _ <- Gtk.widgetSetTooltipText widget $ Just tooltip
          return ()
        return [memoryUsedRatio mi]

      cpuReader :: Gtk.Widget -> IO [Double]
      cpuReader widget = do
        (userLoad, systemLoad, totalLoad) <- cpuLoad
        Gtk.postGUIAsync $ do
          let
            user    = round $ 100 * userLoad   :: Int
            system  = round $ 100 * systemLoad :: Int
            tooltip = printf "%02i%% User\n%02i%% System" user system :: String
          _ <- Gtk.widgetSetTooltipText widget $ Just tooltip
          return ()
        return [totalLoad, systemLoad]

      tempReader :: Gtk.Widget -> IO [Double]
      tempReader widget = do
        ret <- getCPUTemp ["cpu0"]
        Gtk.postGUIAsync $ do
          _ <- Gtk.widgetSetTooltipText widget (Just (show $ ret!!0))
          return ()
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
      mem = do
        ebox <- Gtk.eventBoxNew
        btn <- pollingGraphNew memCfg 1 $ memReader $ Gtk.toWidget ebox
        Gtk.containerAdd ebox btn
        _ <- Gtk.on ebox Gtk.buttonPressEvent systemEvents
        Gtk.widgetShowAll ebox
        return $ Gtk.toWidget ebox


      systemEvents :: Gtk.EventM Gtk.EButton Bool
      systemEvents = do
        e <- Gtk.eventButton
        case e of
          Gtk.LeftButton   -> unsafeSpawn "terminator -e glances"
          Gtk.RightButton  -> unsafeSpawn "terminator -e top"
          Gtk.MiddleButton -> unsafeSpawn "gnome-system-monitor"
          _ -> return ()
        return True

      cpu :: IO Gtk.Widget
      cpu = do
        ebox <- Gtk.eventBoxNew
        btn <- pollingGraphNew cpuCfg 0.5 $ cpuReader $ Gtk.toWidget ebox
        Gtk.containerAdd ebox btn
        _ <- Gtk.on ebox Gtk.buttonPressEvent systemEvents
        Gtk.widgetShowAll ebox
        return $ Gtk.toWidget ebox


      tempEvents :: Gtk.EventM Gtk.EButton Bool
      tempEvents = do
        e <- Gtk.eventButton
        case e of
          Gtk.LeftButton  -> unsafeSpawn "gnome-power-statistics"
          Gtk.RightButton -> unsafeSpawn "terminator -e 'sudo powertop'"
          _ -> return ()
        return True

      temp :: IO Gtk.Widget
      temp = do
        ebox <- Gtk.eventBoxNew
        btn <- pollingGraphNew tempCfg 1 $ tempReader $ Gtk.toWidget ebox
        Gtk.containerAdd ebox btn
        _ <- Gtk.on ebox Gtk.buttonPressEvent tempEvents
        Gtk.widgetShowAll ebox
        return $ Gtk.toWidget ebox

      battEvents :: Gtk.EventM Gtk.EButton Bool
      battEvents = do
        unsafeSpawn "gnome-power-statistics"
        return True

      batt :: IO Gtk.Widget
      batt = do
        btn <- batteryBarNew defaultBatteryConfig 1
        ebox <- Gtk.eventBoxNew
        Gtk.containerAdd ebox btn
        _ <- Gtk.on ebox Gtk.buttonPressEvent battEvents
        Gtk.widgetShowAll ebox
        return $ Gtk.toWidget ebox

      tray :: IO Gtk.Widget
      tray = systrayNew

      weaSMEvents :: Gtk.EventM Gtk.EButton Bool
      weaSMEvents = do
        unsafeSpawn "firefox https://darksky.net/34.0196,-118.487"
        return True

      weaSM :: IO Gtk.Widget
      weaSM = do
        btn <- weatherNew (defaultWeatherConfig "KSMO") { weatherTemplate = "SM $tempF$ °F" } 10
        ebox <- Gtk.eventBoxNew
        Gtk.containerAdd ebox btn
        _ <- Gtk.on ebox Gtk.buttonPressEvent weaSMEvents
        Gtk.widgetShowAll ebox
        return $ Gtk.toWidget ebox

      weaOSEvents :: Gtk.EventM Gtk.EButton Bool
      weaOSEvents = do
        unsafeSpawn "firefox https://darksky.net/30.4113,-88.8279"
        return True

      weaOS :: IO Gtk.Widget
      weaOS = do
        btn <- weatherNew (defaultWeatherConfig "KBIX") { weatherTemplate = "OS $tempF$ °F" } 30
        ebox <- Gtk.eventBoxNew
        Gtk.containerAdd ebox btn
        _ <- Gtk.on ebox Gtk.buttonPressEvent weaOSEvents
        Gtk.widgetShowAll ebox
        return $ Gtk.toWidget ebox

  defaultTaffybar defaultTaffybarConfig { startWidgets = [ pager, note ]
                                        , endWidgets = [ tray, weaOS, weaSM, clock, mem, cpu, batt, temp ]
                                        }
