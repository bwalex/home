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

import XMonad.Util.Run(spawnPipe)

import XMonad.Layout.TwoPane
import XMonad.Layout.MosaicAlt
import XMonad.Layout.Combo
import XMonad.Layout.WindowNavigation

import qualified XMonad.StackSet as W 

import Data.Bits ((.|.))
import qualified Data.Map as M

import System.Exit
import System.IO

-- main = xmonad gnomeConfig
 
--main = xmonad gnomeConfig
main = xmonad defaultConfig
        {	modMask = mod4Mask, -- Use Super instead of Alt
		workspaces       = map show [1 .. 10 :: Int],
		startupHook = myStartupHook,
		manageHook    	= myManageHook <+> manageDocks <+> manageHook desktopConfig,
		logHook = myLogHook
		, layoutHook = avoidStruts (tall)

        -- more changes
        }
	where
		tall 	= Tall 1 (3/100) (1/2)

	        myStartupHook :: X ()
	        myStartupHook = do
			spawn "xterm"
			spawn "lxpanel"

		myLogHook :: X ()
		myLogHook = ewmhDesktopsLogHook

		myManageHook = composeAll
			[ className =? "MPlayer"        --> doFloat
			, className =? "VLC media player"	    --> doFloat
			, className =? "Xfce4-panel"    --> doFloat
			, manageDocks
			]
