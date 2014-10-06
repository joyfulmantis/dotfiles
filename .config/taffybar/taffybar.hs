import Data.Monoid ( mconcat )

import Solarized

import System.Taffybar

import System.Taffybar.Battery
import System.Taffybar.Systray
import System.Taffybar.Pager (colorize, escape, shorten, wrap)
import System.Taffybar.Widgets.PollingLabel
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications

import qualified Data.Text as T

myNotificationFormatter :: Notification -> String
myNotificationFormatter note = wrap " :: " " :: " (colorize solarizedBase03 solarizedRed (escape (shorten 45 msg)))
  where msg = case T.null (noteBody note) of
          True  -> T.unpack $ noteSummary note
          False -> T.unpack $ mconcat [ noteSummary note, noteBody note ]

mySep = colorize solarizedBase1 solarizedBase3 (escape " :: ")

main = do
  let pager         = taffyPagerNew defaultPagerConfig
           { activeWindow      = colorize solarizedGreen    solarizedBase3.escape.shorten 45
           , activeLayout      = colorize solarizedBlue     solarizedBase3.escape
           , activeWorkspace   = colorize solarizedGreen    solarizedBase3.escape
           , hiddenWorkspace   = colorize solarizedMagenta  solarizedBase3.escape
           , emptyWorkspace    = colorize solarizedBase0    solarizedBase3.escape
           , visibleWorkspace  = colorize solarizedBlue     solarizedBase3.escape
           , urgentWorkspace   = colorize solarizedRed      solarizedBase3.escape
           , widgetSep         = mySep }
      clock         = textClockNew Nothing (colorize solarizedOrange solarizedBase3  "%d/%m/%y @ %H:%M" ++ mySep) 60
      battery       = textBatteryNew (colorize solarizedBlue solarizedBase3 "$percentage$%" ++ mySep) 60
      tray          = systrayNew
      notifications = notifyAreaNew defaultNotificationConfig { notificationFormatter = myNotificationFormatter }
  defaultTaffybar defaultTaffybarConfig { barHeight     = 19
                                        , endWidgets    = [ tray, clock, battery, notifications ]
                                        , startWidgets  = [ pager ]
                                        , widgetSpacing = 0
                                        }


           -- , activeWorkspace   = colorize solarizedBase3 solarizedMagenta.escape
           -- , hiddenWorkspace   = colorize solarizedBase3 solarizedOrange.escape
           -- , emptyWorkspace    = colorize solarizedBase3 solarizedGreen.escape
           -- , visibleWorkspace  = colorize solarizedBase3 solarizedBlue.escape
           -- , urgentWorkspace   = colorize solarizedBase3 solarizedRed.escape
