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
; + Click the scrolling text to reverse the scroll direction
;
; /noop $scroller().reverse - Reverses scroll direction
; /noop $scroller().bounce - Toggles bouncing
; ----------------------------------------------------------------
; 2013-09-07 v1.8 Bugfix: Enforce picture window min/max
; 2013-09-07 v1.7 High res timer, toolbar on/off, .reverse .bounce
; 2013-09-07 v1.6 Match-up offset to visually match loop
; 2013-09-05 v1.5 Use one buffer, and negative drawtext offset
; 2013-09-04 v1.4 Add Scroll Bouncing option
; 2013-09-03 v1.3 Scrolling using drawcopy for non-destructive blt
; 2013-09-03 v1.2 Toggle scrolling direction by clicking on button
; 2013-09-03 v1.1 Scrolling using drawscroll
; 2013-09-03 v1.0 Basic framework and drawing. Animation next.
; ----------------------------------------------------------------

; --------- Configuration

alias -l Kin.Scroller.Bounce { return $true }
; ^ Scroll continuously, or bounce back and forth?

alias -l Kin.Scroller.Increment { return -1 }
; ^ How far to scroll (in pixels) for each scrolling update
; -- Negative amount: Begin by scrolling left
; -- Positive amount: Begin by scrolling right

alias -l Kin.Scroller.Milliseconds { return 80 }
; ^ How many milliseconds between animation updates
; -- Use a value no less than 30

alias -l Kin.Scroller.WidthLimit { return 128 }
alias -l Kin.Scroller.HeightLimit { return 16 }
; ^ Maximum toolbar width and height in pixels
; -- (Minimum 16 pixels, maximum 256 pixels)

alias -l Kin.Scroller.Margin { return 6 }
; ^ Margin on the left and right side of the toolbar button

alias -l Kin.Scroller.Spacing { return 12 }
; ^ Extra space between loops

alias -l Kin.Scroller.BackgroundColor { return 12 }
; ^ Toolbar background color

alias -l Kin.Scroller.Font { return "Arial" }
; ^ Font for text. e.g. "Arial" "Arial Rounded MT Bold" "Comic Sans MS" "Times New Roman" "Verdana" ect.
alias -l Kin.Scroller.FontSize { return 14 }
; ^ Font size
alias -l Kin.Scroller.TextColor { return 8 }
; ^ "Base" color for font (ctrl-K/I/B codes can change colors within the string)

alias -l Kin.Scroller.Tooltip { return "Now Playing" }
; ^ Tooltip for the toolbar button

; --------- Alias

alias Scroller {
  ; Scroller methods to toggle bouncing and scroll direction
  if ($isid) && ($prop) {
    if ($prop == reverse) {
      if (%Kin.Scroller.ScrollLeft) { set -e %Kin.Scroller.ScrollLeft $false }
      else { set -e %Kin.Scroller.ScrollLeft $true }
    }
    if ($prop == bounce) { 
      if (%Kin.Scroller.Bounce) { set -e %Kin.Scroller.Bounce $false }
      else { set -e %Kin.Scroller.Bounce $true }
    }
    return
  }

  Kin.Scroller.Stop

  ; Use /Scroller with no parameter to turn off the scroll and remove the button
  if (!$1) { return }

  set -e %Kin.Scroller.String $1-
  set -e %Kin.Scroller.Position 0

  ; Draw Text in Toolbar, and begin scrolling if too large to fit
  if ($Kin.Scroller.DrawText(%Kin.Scroller.Position)) {
    if (!$toolbar) {
      set -e %Kin.Scroller.ToolBarOff $true
      .toolbar on
    }
    set -e %Kin.Scroller.Increment $abs($Kin.Scroller.Increment)
    set -e %Kin.Scroller.ScrollLeft $iif($Kin.Scroller.Increment > 0,$false,$true)
    set -e %Kin.Scroller.Bounce $Kin.Scroller.Bounce

    .timerKin.Scroller.Update -mo 0 $iif($Kin.Scroller.Milliseconds isnum 30-3000,$v1,80) Kin.Scroller.Move 
  }
}

; -------- Drawing Alias

alias -l Kin.Scroller.DrawText {
  var %pos $1
  var %text $iif($2,$2-,%Kin.Scroller.String) $+ $chr(160)
  var %bneedstoscroll $false

  ; ---- Determine text size
  var %textwidth $width(%text,$Kin.Scroller.Font,$Kin.Scroller.FontSize,0,1)
  var %textheight $height(%text,$Kin.Scroller.Font,$Kin.Scroller.FontSize)

  ; ---- Create picture window as a drawing buffer for the toolbar
  var %margin $Kin.Scroller.Margin
  var %viewheight $iif(%textheight > $Kin.Scroller.SizeLimit($Kin.Scroller.HeightLimit),$Kin.Scroller.SizeLimit($Kin.Scroller.HeightLimit),%textheight)
  var %toolbarheight = %viewheight 

  if ($calc(%textwidth + (%margin * 2)) <= $Kin.Scroller.SizeLimit($Kin.Scroller.WidthLimit)) {
    ; Text is short enough to fit without scrolling
    var %viewwidth %textwidth
    var %toolbarwidth $v1
  }
  else {
    ; Text is too long, we need to scroll
    var %viewwidth %textwidth
    dec %viewwidth %margin
    dec %viewwidth %margin
    var %toolbarwidth $Kin.Scroller.SizeLimit($Kin.Scroller.WidthLimit)

    %bneedstoscroll = $true
  }

  ; Enforce picture window limits
  %toolbarheight = $Kin.Scroller.SizeLimit(%toolbarheight)
  %toolbarwidth = $Kin.Scroller.SizeLimit(%toolbarwidth)

  if (!$window($Kin.Scroller.ToolbarBuffer)) { 
    window -hp +d $Kin.Scroller.ToolbarBuffer 64 64 $calc(%toolbarwidth + $Kin.Scroller.BorderSize) $calc(%toolbarheight + $Kin.Scroller.BorderSize)
  }

  ; ---- Draw
  ; Clear 
  drawfill -n $Kin.Scroller.ToolbarBuffer $Kin.Scroller.BackgroundColor $Kin.Scroller.Drawsize 0 0

  ; Draw Text
  var %textpos $calc(%margin + $Kin.Scroller.XOffset + %pos)
  drawtext -npb $Kin.Scroller.ToolbarBuffer $Kin.Scroller.TextColor $Kin.Scroller.BackgroundColor $Kin.Scroller.Font $Kin.Scroller.FontSize $calc(%textpos + $Kin.Scroller.XOffset) $Kin.Scroller.YOffset %text

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
    drawtext -npb $Kin.Scroller.ToolbarBuffer $Kin.Scroller.TextColor $Kin.Scroller.BackgroundColor $Kin.Scroller.Font $Kin.Scroller.FontSize %textpos $Kin.Scroller.YOffset %text
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

alias -l Kin.Scroller.SizeLimit {
  ; mIRC limits on the size of picture windows for use with the toolbar
  if ($1 < 16) { return 16 }
  elseif ($1 > 256) { return 256 }
  elseif ($1 !isnum) { return 36 }
  else { return $1 }
}

alias -l Kin.Scroller.Move {
  var %pos $iif(%Kin.Scroller.Position,$v1,0)
  var %inc $iif(%Kin.Scroller.Increment,$v1,$Kin.Scroller.Increment)
  var %left %Kin.Scroller.ScrollLeft
  var %bbounce %Kin.Scroller.Bounce

  var %max $width(%Kin.Scroller.String,$Kin.Scroller.Font,$Kin.Scroller.FontSize,0,1)
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
    dec %max $Kin.Scroller.SizeLimit($Kin.Scroller.WidthLimit)
    inc %max $Kin.Scroller.Margin
    inc %max $Kin.Scroller.Margin

    ; Bounce
    if (%pos < $calc(0 - %max)) || (%pos >= 0) {
      noop $Scroller().reverse
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
  if (%Kin.Scroller.ToolBarOff) { .toolbar off } 
  .timerKin.Scroller.Update off
  unset %Kin.Scroller.*
}

alias -l Kin.Scroller.Click {
  ; Switch the direction of the scroll when the toolbar is clicked
  noop $scroller().reverse
}

; -------- Support Configuration

alias Kin.Scroller.Drawsize { return 1 }
alias Kin.Scroller.YOffset { return -2 }
alias Kin.Scroller.XOffset { return 2 }
alias Kin.Scroller.MatchupOffset { return 5 }
alias Kin.Scroller.BorderSize { return 2 }

alias Kin.Scroller.ToolbarName { return Kin.Scroller }
alias Kin.Scroller.ToolbarBuffer { return @Kin.Scroller.TempBuffer }
