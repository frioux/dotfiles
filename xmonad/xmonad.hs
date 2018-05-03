import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import System.IO
import XMonad.Hooks.EwmhDesktops (ewmh)
import System.Taffybar.Hooks.PagerHints (pagerHints)

main = do
    xmonad $ ewmh $ pagerHints $ desktopConfig {
        manageHook = composeAll
        [ className =? "trayer" --> doIgnore
        , manageDocks
        , manageHook desktopConfig
        ],
        layoutHook = avoidStruts  $  layoutHook desktopConfig,
        terminal = "terminator",
        modMask = modMask'
        } `additionalKeys` myKeys `additionalKeysP` myKeys2

myKeys2 = [("M-<Return>", spawn "terminator")
        ,  ("M-b", sendMessage ToggleStruts)
        ,  ("M-S-x", spawn "lock-now")
        ,  ("M-d", spawn "showdm")
        ,  ("M-u",  spawn "showuni")
        ,  ("M-v",  spawn "showsession")
        ,  ("<XF86AudioMute>", spawn "vol toggle")
        ,  ("<XF86AudioLowerVolume>", spawn "vol down")
        ,  ("<XF86AudioRaiseVolume>", spawn "vol up")
        ,  ("<XF86MonBrightnessDown>", spawn "backlight -10")
        ,  ("<XF86MonBrightnessUp>",   spawn "backlight  10")
        ,  ("M-S-i", spawn "xcalib -i -a")
          ]

myKeys = [((m .|. modMask', key), screenWorkspace sc >>= flip whenJust (windows . f))
                | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2]
                , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- |=
-- =|

-- --
-- ‥‥

-- ‥‥
-- --

-- ⧈

modMask' :: KeyMask
modMask' = mod4Mask
