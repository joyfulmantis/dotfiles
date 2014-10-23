import           Graphics.X11.ExtraTypes.XF86

import           Solarized

import           System.Exit

import           PagerHints                   (pagerHints)

import           XMonad

import           XMonad.Hooks.EwmhDesktops    (ewmh)
import           XMonad.Hooks.ManageDocks

import           XMonad.Layout.Fullscreen
import           XMonad.Layout.Renamed

import qualified Data.Map                     as M
import qualified XMonad.StackSet              as W

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    --spawn dmenu
    , ((modm,               xK_p     ), spawn $ "dmenu_run -fn Inconsolata-12 -nb '" ++ solarizedBase3 ++ "' -nf '" ++ solarizedBase00 ++ "' -sb '" ++ solarizedBase2 ++ "' -sf '" ++ solarizedBase01 ++ "'")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_parenleft, xK_parenright
                                                 ,xK_braceright, xK_plus
                                                 ,xK_braceleft, xK_bracketright
                                                 ,xK_bracketleft, xK_exclam
                                                 ,xK_equal]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myLayoutHook = fullscreenFull (avoidStruts (renamed [Replace "高"] (tall) ||| renamed [Replace "宽"] (Mirror tall) ||| renamed [Replace "全"] (Full)))
    where  tall = Tall 1 (3/100) (1/2)

myWorkspaces    = ["一","二","三","四","五","六","七","八","九"]

main = xmonad $ ewmh $ pagerHints $ defaultConfig
                { borderWidth        = 2
                , focusedBorderColor = solarizedBase2
                , handleEventHook    = handleEventHook defaultConfig <+> fullscreenEventHook <+> docksEventHook
                , keys               = myKeys
                , layoutHook	     = myLayoutHook
		, manageHook	     = manageHook defaultConfig <+> manageDocks
		, modMask	     = mod1Mask
                , normalBorderColor  = solarizedBase3
                , terminal           = "gnome-terminal"
                , workspaces         = myWorkspaces }
