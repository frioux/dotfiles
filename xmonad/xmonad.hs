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

import XMonad.Actions.CopyWindow

import XMonad.Actions.SwapWorkspaces

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
   `additionalKeysP` [
      ,("M-d", spawn "/home/frew/bin/showdm")
      ,("<Pause>", spawn "/home/frew/bin/showdm")
      ,("M-v", windows copyToAll)
      ,("M-S-v",  killAllOtherCopies)
   ]
