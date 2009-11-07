import XMonad

import XMonad.ManageHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W

import qualified XMonad.Prompt as P
import qualified XMonad.Actions.Submap as SM
import qualified XMonad.Actions.Search as S


{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-UrgencyHook.html -}
import XMonad.Hooks.UrgencyHook

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html -}
import XMonad.Util.EZConfig

{- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-Dzen.html -}
import XMonad.Util.Dzen

import XMonad.Actions.CopyWindow

import XMonad.Actions.SwapWorkspaces

dbus_amarok = "dbus-send --type=method_call --dest=org.kde.amarok /Player org.freedesktop.MediaPlayer."

searchList :: [(String, S.SearchEngine)]
searchList = [
    ("g", S.google)
   ,("w", S.wikipedia)
   ,("d", (S.searchEngine "cpan" "http://search.cpan.org/search?q="))
   ,("c", (S.searchEngine "cpan-define" "http://search.cpan.org/perldoc?"))
   ,("p", (S.searchEngine "perldoc" "http://perldoc.perl.org/search.html?q="))
   ]

main = xmonad
   $ withUrgencyHook dzenUrgencyHook
   $ defaultConfig {
      manageHook = manageDocks <+> manageHook defaultConfig,
      logHook    = ewmhDesktopsLogHook,
      layoutHook = ewmhDesktopsLayout
         $ avoidStruts
         $ layoutHook defaultConfig
   }
   `additionalKeys` [
      ((mod1Mask .|. controlMask, k), windows $ swapWithCurrent i)
           | (i, k) <- zip (workspaces defaultConfig) [xK_1 ..]
   ]
   `additionalKeysP`( [
         ("M-d", spawn "/home/frew/bin/showdm")
         ,("<Pause>", spawn "/home/frew/bin/showdm")
         ,("<XF86AudioPlay>", spawn ( dbus_amarok++"PlayPause" ))
         ,("<XF86AudioMute>", spawn ( dbus_amarok++"Pause" ))
         ,("<XF86WWW>", spawn "firefox")
         ,("M-v", windows copyToAll)
         ,("M-S-v",  killAllOtherCopies)
      ]
      ++ [("M-s " ++ k, S.promptSearch P.defaultXPConfig f) | (k,f) <- searchList ]
      ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ])
