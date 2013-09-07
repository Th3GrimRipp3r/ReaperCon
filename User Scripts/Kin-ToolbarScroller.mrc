; ----------------------------------------------------------------
; Kin's Toolbar Scroller - mSL for mIRC
; ----------------------------------------------------------------
; #ReaperCon #mIRC #Script-Help #Bots #RegEx - IRC.GeekShed.Net
; Hosted at https://github.com/Th3GrimRipp3r/ReaperCon
; 2013-09-03
; Requested by Coyote #ReaperCon irc.GeekShed.Net
; ----------------------------------------------------------------
; Adds a scrolling text crawl to the mIRC toolbar
;   -> Requires mIRC v7.x
; Also a basic demo for drawing on picture windows and /toolbar
; ----------------------------------------------------------------
; Usage:
;   /scroller Formatted text to scroll
;       - Adds the formatted text to the toolbar scroll
;   /scroller
;       - Stops the scrolling and remove the text from the toolbar
;
; + Clicking on the scrolling text reverses the scroll direction
; ----------------------------------------------------------------
; 2013-09-07 v1.6 Match-up offset to visually match loop
; 2013-09-05 v1.5 Use one buffer, and negative drawtext offset
; 2013-09-04 v1.4 Add Scroll Bouncing option
; 2013-09-03 v1.3 Scrolling using drawcopy for non-destructive blt
; 2013-09-03 v1.2 Toggle scrolling direction by clicking on button
; 2013-09-03 v1.1 Scrolling using drawscroll
; 2013-09-03 v1.0 Basic framework and drawing. Animation next.
; ----------------------------------------------------------------

; --------- Configuration

alias Kin.Scroller.Increment { return -8 }
; ^ How far to scroll (in pixels) for each scrolling update
; -- Negative amount: Begin by scrolling left
; -- Positive amount: Begin by scrolling right

alias Kin.Scroller.Bounce { return $false }
; ^ Scroll continuously, or bounce back and forth?

alias Kin.Scroller.WidthLimit { return 256 }
alias Kin.Scroller.HeightLimit { return 19 }
; ^ Maximum toolbar width and height (in pixels)

alias Kin.Scroller.Margin { return 6 }
; ^ Margin on the left and right side of the toolbar button

alias Kin.Scroller.Spacing { return 12 }
; ^ Extra space between loops

alias Kin.Scroller.BackgroundColor { return 12 }
; ^ Toolbar background color

alias Kin.Scroller.Font { return Arial }
alias Kin.Scroller.Size { return 18 }
alias Kin.Scroller.TextColor { return 8 }
; ^ Font for text, and "base" color (ctrl-K/I/B codes in the string will still work)

alias Kin.Scroller.Tooltip { return Now_Playing }
; ^ Tooltip (must be one word) for the toolbar button

; --------- Alias

alias Scroller {
  Kin.Scroller.Stop

  ; Use /Scroller with no parameter to turn off the scroll and remove the button
  if (!$1) { return }

  set -e %Kin.Scroller.String $1-
  set -e %Kin.Scroller.Position 0

  ; Draw Text in Toolbar, and begin scrolling if too large to fit
  if ($Kin.Scroller.DrawText(%Kin.Scroller.Position)) {
    set -e %Kin.Scroller.Increment $abs($Kin.Scroller.Increment)
    set -e %Kin.Scroller.ScrollLeft $iif($Kin.Scroller.Increment > 0,$false,$true)
    set -e %Kin.Scroller.Bounce $Kin.Scroller.Bounce

    .timerKin.Scroller.Update 0 1 Kin.Scroller.Move 
  }
}

; -------- Drawing Alias

alias Kin.Scroller.DrawText {
  var %pos $1
  var %text $iif($2,$2-,%Kin.Scroller.String) $+ $chr(160)
  var %bneedstoscroll $false

  ; ---- Determine text size
  var %textwidth $width(%text,$Kin.Scroller.Font,$Kin.Scroller.Size,0,1)
  var %textheight $height(%text,$Kin.Scroller.Font,$Kin.Scroller.Size)

  ; ---- Create picture window as a drawing buffer for the toolbar
  var %margin $Kin.Scroller.Margin
  var %viewheight $iif(%textheight > $Kin.Scroller.HeightLimit,$Kin.Scroller.HeightLimit,%textheight)
  var %toolbarheight = %viewheight 

  if ($calc(%textwidth + (%margin * 2)) <= $Kin.Scroller.WidthLimit) {
    ; Text is short enough to fit without scrolling
    var %viewwidth %textwidth
    var %toolbarwidth $v1
  }
  else {
    ; Text is too long, we need to scroll
    var %viewwidth %textwidth
    dec %viewwidth %margin
    dec %viewwidth %margin
    var %toolbarwidth $Kin.Scroller.WidthLimit

    %bneedstoscroll = $true
  }

  if (!$window($Kin.Scroller.ToolbarBuffer)) { 
    window -hp +d $Kin.Scroller.ToolbarBuffer 64 64 $calc(%toolbarwidth + $Kin.Scroller.BorderSize) $calc(%toolbarheight + $Kin.Scroller.BorderSize)
  }

  ; ---- Draw
  ; Clear 
  drawfill -n $Kin.Scroller.ToolbarBuffer $Kin.Scroller.BackgroundColor $Kin.Scroller.Drawsize 0 0

  ; Draw Text
  var %textpos $calc(%margin + $Kin.Scroller.XOffset + %pos)
  drawtext -npb $Kin.Scroller.ToolbarBuffer $Kin.Scroller.TextColor $Kin.Scroller.BackgroundColor $Kin.Scroller.Font $Kin.Scroller.Size %textpos $Kin.Scroller.YOffset %text

  ; Draw second copy of text if continuously looping
  if (!%Kin.Scroller.Bounce) {
    if (%textpos > %margin) {
      dec %textpos %textwidth
      dec %textpos $Kin.Scroller.Spacing
    }
    else {
      inc %textpos %textwidth
      inc %textpos $Kin.Scroller.Spacing
    }
    drawtext -npb $Kin.Scroller.ToolbarBuffer $Kin.Scroller.TextColor $Kin.Scroller.BackgroundColor $Kin.Scroller.Font $Kin.Scroller.Size %textpos $Kin.Scroller.YOffset %text
  }

  ; Clear Margins
  drawrect -nf $Kin.Scroller.ToolbarBuffer $Kin.Scroller.BackgroundColor $Kin.Scroller.Drawsize 0 0 %margin %toolbarheight
  drawrect -nf $Kin.Scroller.ToolbarBuffer $Kin.Scroller.BackgroundColor $Kin.Scroller.Drawsize $calc(%toolbarwidth - %margin) 0 %margin %toolbarheight

  ; ---- Blt surface to toolbar
  if (!$toolbar($Kin.Scroller.ToolbarName)) {
    toolbar -ax $Kin.Scroller.ToolbarName $Kin.Scroller.Tooltip $Kin.Scroller.ToolbarBuffer 0 0 %toolbarwidth %toolbarheight /Kin.Scroller.Click
  }
  else {
    toolbar -p $Kin.Scroller.ToolbarName $Kin.Scroller.ToolbarBuffer 0 0 %toolbarwidth %toolbarheight
  }

  if ($isid) { return %bneedstoscroll }
}

; -------- Support Aliases

alias Kin.Scroller.Move {
  var %pos $iif(%Kin.Scroller.Position,$v1,0)
  var %inc $iif(%Kin.Scroller.Increment,$v1,$Kin.Scroller.Increment)
  var %left %Kin.Scroller.ScrollLeft
  var %bbounce %Kin.Scroller.Bounce

  var %max $width(%Kin.Scroller.String,$Kin.Scroller.Font,$Kin.Scroller.Size,0,1)
  inc %max $Kin.Scroller.MatchupOffset

  ; Move
  if (%left) { dec %pos %inc }
  else { inc %pos %inc }

  ; Continuous scrolling
  if (!%bbounce) {
    ; The second loop of text needs spacing
    inc %max $Kin.Scroller.Spacing

    ; Loop
    if (%pos < 0) || (%pos >= %max) {
      %pos = $calc( (%max + (%pos % %max)) % %max)
    }
  }
  ; Bouncing motion
  else {
    ; How much hidden text is there when bouncing between left and right
    dec %max $Kin.Scroller.WidthLimit
    inc %max $Kin.Scroller.Margin
    inc %max $Kin.Scroller.Margin

    ; Bounce
    if (%pos < $calc(0 - %max)) || (%pos >= 0) {
      Kin.Scroller.Reverse 
      %pos = $calc(0 - (%max + (%pos % %max)) % %max))
    }
  }

  Kin.Scroller.DrawText %pos
  set -e %Kin.Scroller.Position %pos
}

alias -l Kin.Scroller.Stop {
  ; Clear previous buffer and button
  if ($window($Kin.Scroller.ToolbarBuffer)) { window -c $Kin.Scroller.ToolbarBuffer }
  if ($toolbar($Kin.Scroller.ToolbarName)) { toolbar -d $Kin.Scroller.ToolbarName }
  .timerKin.Scroller.Update off
  unset %Kin.Scroller.*
}

alias Kin.Scroller.Reverse {
  if (%Kin.Scroller.ScrollLeft) { set -e %Kin.Scroller.ScrollLeft $false }
  else { set -e %Kin.Scroller.ScrollLeft $true }
}

alias Kin.Scroller.Click {
  ; Switch the direction of the scroll when the toolbar is clicked
  Kin.Scroller.Reverse
}

; -------- Support Configuration

alias Kin.Scroller.Drawsize { return 1 }
alias Kin.Scroller.YOffset { return -2 }
alias Kin.Scroller.XOffset { return 2 }
alias Kin.Scroller.MatchupOffset { return 5 }
alias Kin.Scroller.BorderSize { return 2 }

alias Kin.Scroller.ToolbarName { return Kin.Scroller }
alias Kin.Scroller.ToolbarBuffer { return @Kin.Scroller.TempBuffer }
