import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.EwmhDesktops (ewmh)
import System.Taffybar.Hooks.PagerHints (pagerHints)

main = do
    xmonad $ ewmh $ pagerHints $ defaultConfig {
        manageHook = composeAll
        [ className =? "trayer" --> doIgnore
        , manageDocks
        , manageHook defaultConfig
        ],
        layoutHook = avoidStruts  $  layoutHook defaultConfig,
        terminal = "terminator",
        modMask = modMask'
        } `additionalKeys` myKeys


myKeys = [ ((modMask', xK_Return), spawn "terminator")
        , ((modMask', xK_b ), sendMessage ToggleStruts)
        , ((modMask' .|. shiftMask, xK_x), spawn "xautolock -locknow")
        , ((modMask', xK_d), spawn "showdm")
        , ((modMask', xK_u), spawn "showuni")
        , ((modMask', xK_v), spawn "showsession")
        , ((modMask', xK_F5), spawn "backlight -10")
        , ((modMask', xK_F6), spawn "backlight 10")
        , ((modMask' .|. shiftMask, xK_i), spawn "xcalib -i -a")
        ]
        ++
        [((m .|. modMask', key), screenWorkspace sc >>= flip whenJust (windows . f))
                | (key, sc) <- zip [xK_w, xK_e, xK_r] [2,0,1]
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
