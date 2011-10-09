import XMonad
--import XMonad.Config.Gnome
import XMonad.Config.Desktop

import XMonad.Actions.CycleWS
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.Submap
import XMonad.Actions.WindowGo

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.RestoreMinimized

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig

import XMonad.Layout.HintedTile
import XMonad.Layout.Grid
import XMonad.Layout.TwoPane
import XMonad.Layout.MosaicAlt
import XMonad.Layout.Combo
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Minimize
import XMonad.Layout.ShowWName

import qualified XMonad.StackSet as W 

import Data.Bits ((.|.))
import qualified Data.Map as M

import System.Exit
import System.IO

-- main = xmonad gnomeConfig

main = xmonad $ ewmh defaultConfig
	{ modMask	= mod4Mask -- Use Super instead of Alt
	, terminal	= "Terminal"
	, workspaces	= map show [1 .. 10 :: Int]
	, startupHook	= myStartupHook
	, manageHook	= myManageHook <+> manageDocks <+> manageHook desktopConfig
	, logHook	= myLogHook
	, layoutHook	= windowNavigation (minimize (hintedTile XMonad.Layout.HintedTile.Tall ||| hintedTile Wide ||| Grid) ||| Full)
		-- had XMonad.Tall 1 (3/100) (1/2)  -- but replaced with hintedTile
		--
		-- add avoidStruts $
		-- at the beginning of layoutHook for panel persistence
		-- no good with avant-window-navigator, but required for
		-- fbpanel, lxpanel, xfce4-panel, etc
	, handleEventHook = myHandleEventHook
	}
	`additionalKeys`
	[ ((mod4Mask, xK_n        		), withFocused (\f -> sendMessage (MinimizeWin f)))
	, ((mod4Mask .|. shiftMask, xK_n	), sendMessage RestoreNextMinimizedWin)
	, ((mod4Mask, xK_Up			), sendMessage $ Swap U)
	, ((mod4Mask, xK_Down			), sendMessage $ Swap D)
	, ((mod4Mask, xK_Left			), sendMessage $ Swap L)
	, ((mod4Mask, xK_Right			), sendMessage $ Swap R)
	]
	`additionalKeysP`
	[ ("<XF86AudioRaiseVolume>"		 , spawn "amixer set Master 5%+ unmute")
	, ("<XF86AudioLowerVolume>"		 , spawn "amixer set Master 5%- unmute")
	, ("<XF86AudioMute>"			 , spawn "amixer set Master toggle")
	, ("<Print>"				 , spawn "shutter")
	]
	where
		hintedTile = HintedTile nmaster delta ratio TopLeft
		nmaster	= 1
		ratio	= 1/2
		delta	= 3/100

		myStartupHook :: X ()
		myStartupHook = do
			spawn "avant-window-navigator"
			spawn "gnome-power-manager"
			spawn "nm-applet"

		myLogHook :: X ()
		myLogHook = ewmhDesktopsLogHook

		myManageHook = composeAll
			[ className =? "MPlayer"		--> doFloat
			, className =? "VLC media player"	--> doFloat
			, manageDocks
			]

		myHandleEventHook = restoreMinimizedEventHook
