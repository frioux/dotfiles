import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myXmonadBar = "dzen2 -x 0 -y 0 -h 24 -w 500 -ta l -fg '#FFFFFF' -bg '#1B1D1E' -e ''"

main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    xmonad $ defaultConfig {
        manageHook = manageDocks <+> manageHook defaultConfig,
        layoutHook = avoidStruts  $  layoutHook defaultConfig,
        logHook = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd,
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

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
      , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E" .
                                (\x -> case x of
                                    "ResizableTall"             ->      "RT"
                                    "Mirror ResizableTall"      ->      "MRT"
                                    "Full"                      ->      "F"
                                    "Simple Float"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }
