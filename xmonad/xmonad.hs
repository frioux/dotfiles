import XMonad

import XMonad.ManageHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-UrgencyHook.html -}
import XMonad.Hooks.UrgencyHook

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html -}
import XMonad.Util.EZConfig

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-Dzen.html -}
import XMonad.Util.Dzen


main = xmonad $ withUrgencyHook dzenUrgencyHook {
                  args = ["-bg", "darkgreen", "-xs", "1"]
            } $ defaultConfig {
                  manageHook = manageDocks <+> manageHook defaultConfig,
                  logHook    = ewmhDesktopsLogHook,
                  layoutHook = ewmhDesktopsLayout $ avoidStruts
                                                  $ layoutHook defaultConfig
            }
            `additionalKeys`
                 [
                  ((mod1Mask, xK_y        ), dzen "Hi, mom!" 5000000),
                  ((mod1Mask, xK_m        ), spawn "xterm"),
                  ((mod1Mask, xK_x        ), spawn "/home/frew/bin/showdm")
                 ]
