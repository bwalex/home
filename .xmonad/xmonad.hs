import XMonad

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
import XMonad.Layout.ResizableTile
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders

import XMonad.Config.Kde
import qualified XMonad.StackSet as W -- to shift and float windows


import Data.Bits ((.|.))
import qualified Data.Map as M

import System.Exit
import System.IO

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

myKeys= [ ((mod4Mask, xK_n ), withFocused minimizeWindow)
        , ((mod4Mask .|. shiftMask, xK_n ), sendMessage RestoreNextMinimizedWin)
        , ((mod4Mask, xK_Up ), sendMessage $ Swap U)
        , ((mod4Mask, xK_Down ), sendMessage $ Swap D)
        , ((mod4Mask, xK_Left ), sendMessage $ Swap L)
        , ((mod4Mask, xK_Right ), sendMessage $ Swap R)
        , ((mod4Mask, xK_u ), sendMessage ExpandSlave)
        , ((mod4Mask, xK_i ), sendMessage ShrinkSlave)
        , ((mod4Mask, xK_a ), sendMessage MirrorExpand >> sendMessage ExpandSlave >> withFocused (sendMessage . expandWindowAlt))
        , ((mod4Mask, xK_z ), sendMessage MirrorShrink >> sendMessage ShrinkSlave >> withFocused (sendMessage . shrinkWindowAlt))
        , ((mod4Mask, xK_s ), withFocused (sendMessage . tallWindowAlt))
        , ((mod4Mask, xK_d ), withFocused (sendMessage . wideWindowAlt))
        , ((mod4Mask .|. shiftMask, xK_a ), sendMessage resetAlt)
        , ((mod4Mask .|. shiftMask, xK_z ), sendMessage resetAlt)
        ]

myKeysP= [ ("M-" ++ m ++ show k, windows $ onCurrentScreen f i)
           | (i, k) <- zip(myWorkspaces) [1,2,3,4,5,6,7,8,9,0]
           , (f, m) <- [(W.view, ""), (W.shift, "S-")]
         ]


main = do
    nScreens <- countScreens
    xmonad $ kde4Config
      { modMask = mod4Mask -- use the Windows button as mod
      , workspaces = withScreens nScreens myWorkspaces
      , manageHook = ((className =? "krunner") >>= return . not --> manageHook kde4Config <+> myManageHook)
      , layoutHook = avoidStruts $ smartBorders $ windowNavigation (minimize (mouseResizableTile ||| mouseResizableTileMirrored) ||| Full)
      , handleEventHook = myHandleEventHook <+> docksEventHook
      }
      `additionalKeys` myKeys
      `additionalKeysP` myKeysP


myHandleEventHook = restoreMinimizedEventHook
 
myManageHook = composeAll . concat $
    [ [ className   =? c --> doFloat           | c <- myFloats]
    , [ className   =? c --> doIgnore          | c <- myIgnores]
    , [ title       =? t --> doFloat           | t <- myOtherFloats]
    , [ className   =? c --> doF (W.shift "0") | c <- w0Apps]
    , [ className   =? c --> doF (W.shift "1") | c <- w1Apps]
    , [ className   =? c --> doF (W.shift "2") | c <- w2Apps]
    , [ className   =? c --> doF (W.shift "3") | c <- w3Apps]
    , [ isFullscreen     --> doFullFloat]
    , [ manageDocks]
    ]
  where myFloats      = [ "MPlayer"
                        , "Gimp"
                        , "Plasma-desktop"
                        , "VLC media player"
                        , "MPlayer"
                        , "Klipper"
                        ]
	myIgnores     = [ "krunner"
                        ]
        myOtherFloats = [ "alsamixer"
                        ]
        w0Apps        = []
        w1Apps        = []
        w2Apps        = []
        w3Apps        = []
