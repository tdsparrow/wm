import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName

myManageHook :: [ManageHook]
myManageHook =
             [ resource =? "Do"  --> doIgnore 
             , resource =? "java" --> doIgnore
			 , resource =? "Fetchmailconf" --> doIgnore ]

main = do
  xmproc <- spawnPipe "/home/erenlii/.cabal/bin/xmobar /home/erenlii/.xmobarrc"
  xmonad $ defaultConfig
     { manageHook = manageDocks <+> manageHook defaultConfig <+> composeAll myManageHook
     , layoutHook = avoidStruts  $  layoutHook defaultConfig
     , startupHook = setWMName "LG3D"               
     , logHook = dynamicLogWithPP xmobarPP               
                 { ppOutput = hPutStrLn xmproc ,
                   ppTitle = xmobarColor "green" "". shorten 50
                 }
     , modMask = mod4Mask     -- Rebind Mod to the Windows key
     } `additionalKeys`
     [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
     , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
     , ((0, xK_Print), spawn "scrot")
     ]
