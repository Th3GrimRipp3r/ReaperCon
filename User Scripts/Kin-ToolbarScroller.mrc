; ----------------------------------------------------------------
; Kin's Toolbar Scroller - mSL for mIRC
; ----------------------------------------------------------------
; #ReaperCon #mIRC #Script-Help #Bots #RegEx - IRC.GeekShed.Net
; Hosted at https://github.com/Th3GrimRipp3r/ReaperCon
; 2013-09-03
; Requested by Coyote #ReaperCon irc.GeekShed.Net
; ----------------------------------------------------------------
; Adds a scrolling text crawl to the mIRC toolbar
;   -> Requires mIRC v7.25 or greater (for drawtext)
; Also a basic demo for drawing on picture windows and /toolbar
; ----------------------------------------------------------------
; Usage:
;   /scroller Formatted text to scroll
;       - Adds the formatted text to the toolbar scroll
;   /scroller
;       - Stops the scrolling and remove the text from the toolbar
; ----------------------------------------------------------------
; 2013-09-03 v1.0 Basic framework and drawing. Animation next.
; ----------------------------------------------------------------

; --------- Configuration

; Toolbar width and height limits in pixels
alias -l Kin.Scroller.WidthLimit { return 256 }
alias -l Kin.Scroller.HeightLimit { return 17 }

; Text font and color
alias -l Kin.Scroller.Font { return Arial }
alias -l Kin.Scroller.Size { return 18 }
alias -l Kin.Scroller.TextColor { return 8 }
alias -l Kin.Scroller.BackgroundColor { return 12 }

; Tooltip (must be one word) for the toolbar button
alias -l Kin.Scroller.Tooltip { return Now_Playing }

; --------- Alias

alias Scroller {
  ; Clear previous buffer and button
  if ($window($Kin.Scroller.PicBuffer)) { window -c $Kin.Scroller.PicBuffer }
  if ($toolbar($Kin.Scroller.ToolbarName)) { toolbar -d $Kin.Scroller.ToolbarName }

  ; Use /Scroller with no parameter to turns off the scroll and remove the button
  if (!$1) { .timerKin.Scroller.Update off | return }

  ; What is the width of our text?
  var %text $1- $+ $chr(160)
  var %textheight $height(%text,$Kin.Scroller.Font,$Kin.Scroller.Size)
  var %textwidth $width(%text,$Kin.Scroller.Font,$Kin.Scroller.Size,0,1)
  inc %textwidth $Kin.Scroller.Offset

  ; Draw the text on a picture window
  window -hp +d $Kin.Scroller.PicBuffer 0 0 $calc(%textwidth + ($Kin.Scroller.Drawsize * 2)) %textheight
  drawfill -n $Kin.Scroller.PicBuffer $Kin.Scroller.BackgroundColor $Kin.Scroller.Drawsize 0 0
  drawtext -pb $Kin.Scroller.PicBuffer $Kin.Scroller.TextColor $Kin.Scroller.BackgroundColor $Kin.Scroller.Font $Kin.Scroller.Size $Kin.Scroller.Offset $calc(0 - $Kin.Scroller.Offset) %text

  ; Figure out if we need to scroll
  var %toolbarheight $iif(%textheight > $Kin.Scroller.HeightLimit,$Kin.Scroller.HeightLimit,%textheight)
  var %toolbarwidth
  if (%textwidth > $Kin.Scroller.WidthLimit) {
    %toolbarwidth = $Kin.Scroller.WidthLimit
    ; Start scroll timer
  }
  else { %toolbarwidth = %textwidth }

  ; Set text to toolbar
  toolbar -ax $Kin.Scroller.ToolbarName $Kin.Scroller.Tooltip $Kin.Scroller.PicBuffer 0 0 %toolbarwidth %toolbarheight /Kin.Scroller.Click
}

alias Kin.Scroller.Click {
}

alias -l Kin.Scroller.PicBuffer { return @Kin.Scroller.pictemp }
alias -l Kin.Scroller.ToolbarName { return Kin.Scroller }
alias -l Kin.Scroller.Drawsize { return 3 }
alias -l Kin.Scroller.Offset { return 2 }
