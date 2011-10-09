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
import XMonad.Hooks.SetWMName

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
	, terminal	= "konsole"
	, workspaces	= map show [1 .. 10 :: Int]
	, startupHook	= myStartupHook
	, manageHook	= myManageHook <+> manageDocks <+> manageHook desktopConfig
	, logHook	= myLogHook
	, layoutHook	= avoidStruts $ windowNavigation (minimize (hintedTile XMonad.Layout.HintedTile.Tall ||| hintedTile Wide ||| Grid ||| MosaicAlt M.empty) ||| Full)
		-- had XMonad.Tall 1 (3/100) (1/2)  -- but replaced with hintedTile
		--
		-- add avoidStruts $
		-- at the beginning of layoutHook for panel persistence
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
	, ((mod4Mask, xK_a			), withFocused (sendMessage . expandWindowAlt))
	, ((mod4Mask, xK_z			), withFocused (sendMessage . shrinkWindowAlt))
	, ((mod4Mask, xK_s			), withFocused (sendMessage . tallWindowAlt))
	, ((mod4Mask, xK_d			), withFocused (sendMessage . wideWindowAlt))
	, ((mod4Mask .|. shiftMask, xK_a	), sendMessage resetAlt)
	, ((mod4Mask .|. shiftMask, xK_z	), sendMessage resetAlt)
	]
	`additionalKeysP`
	[ ("<XF86AudioRaiseVolume>"		 , spawn "amixer set Master 5%+ unmute ; killall osd_cat &> /dev/null ; osd_cat -d 2 -l 2 -p bottom -c green -T \"Volume (Master)\" -b percentage -P `amixer get Master | grep 'Front Left:' | cut -d \" \" -f 7 | sed 's/[^0-9]//g'`")
	, ("<XF86AudioLowerVolume>"		 , spawn "amixer set Master 5%- unmute ; killall osd_cat &> /dev/null ; osd_cat -d 2 -l 2 -p bottom -c green -T \"Volume (Master)\" -b percentage -P `amixer get Master | grep 'Front Left:' | cut -d \" \" -f 7 | sed 's/[^0-9]//g'`")
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
			----spawn "avant-window-navigator"
			spawn "xfce4-panel --disable-wm-check"
			spawn "gnome-keyring-daemon --start"
			----spawn "/usr/libexec/gnome-settings-daemon"
			spawn "gnome-power-manager"
			spawn "nm-applet"
			--spawn "gnome-session"

		myLogHook :: X ()
		myLogHook = do
			setWMName "LG3D"
		--myLogHook = ewmhDesktopsLogHook

		myManageHook = composeAll
			[ className =? "MPlayer"		--> doFloat
			, className =? "VLC media player"	--> doFloat
			, manageDocks
			]

		myHandleEventHook = restoreMinimizedEventHook
