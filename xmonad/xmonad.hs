import XMonad

-- everything qualified for readability
-- Docs at: http://xmonad.org/xmonad-docs/xmonad-contrib/($module =~ s/./-/r).html
import qualified XMonad.Hooks.ManageDocks   as ManageDocks
import qualified XMonad.Hooks.EwmhDesktops  as EwmhDesktops
import qualified XMonad.StackSet            as StackSet
import qualified XMonad.Layout.NoBorders    as NoBorders
import qualified XMonad.Hooks.ManageHelpers as ManageHelpers
import qualified XMonad.Hooks.UrgencyHook   as UrgencyHook

-- can't figure out how to qualify this
import XMonad.Util.EZConfig

myManageHooks = ManageDocks.manageDocks <+> composeAll
-- Allows focusing other monitors without killing the fullscreen
   {-[ ManageHelpers.isFullscreen --> (doF StackSet.focusDown <+> ManageHelpers.doFullFloat) ]-}

   -- Works on laptop:
    [ ManageHelpers.isFullscreen --> ManageHelpers.doFullFloat ]

main = xmonad
   $ UrgencyHook.withUrgencyHook UrgencyHook.dzenUrgencyHook
   $ EwmhDesktops.ewmh defaultConfig {
      terminal   = "terminator",
      manageHook = myManageHooks,
      logHook    = EwmhDesktops.ewmhDesktopsLogHook,
      layoutHook = NoBorders.smartBorders (
         ManageDocks.avoidStruts
         $ layoutHook defaultConfig
      )
   }
   -- hotkeys
   `additionalKeysP`([
         ("M-d", spawn "/home/frew/bin/showdm"),
         ("M-S-d", spawn "gmrun"),
         ("M-f", spawn "/home/frew/tmp/firefox/firefox")
      ])
