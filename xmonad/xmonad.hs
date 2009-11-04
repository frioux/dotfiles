import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.UrgencyHook
import qualified XMonad.StackSet as W

main = xmonad $ withUrgencyHook dzenUrgencyHook {
                  args = ["-bg", "darkgreen", "-xs", "1"]
            } $ defaultConfig {
                  manageHook = manageDocks <+> manageHook defaultConfig,
                  logHook    = ewmhDesktopsLogHook,
                  layoutHook = ewmhDesktopsLayout $ avoidStruts
                                                  $ layoutHook defaultConfig
            }
