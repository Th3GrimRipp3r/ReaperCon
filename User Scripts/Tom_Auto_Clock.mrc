; Tom's Clock Script using Kin's Toolbar Scroller
; ----------------------------------------------------------------
; Kin's Toolbar Scroller - mSL for mIRC
; ----------------------------------------------------------------
; Tom's Clock Config
; --------- Configuration
menu menubar,status {
  Tom's Titlebar Clock
  .Auto Start ( $+ %AutoClock $+ ):
  ..$iif((%AutoClock !== $null),$style(1)) Currently ( $+ %AutoClock $+ ) (click to Toggle $iif(%Autoclock == off,ON,OFF) $+ ):.toggleclockswitch
  .Clock ( $+ %Clock $+ ):
  ..$iif((%Clock !== $null),$style(1)) Currently ( $+ %Clock $+ ) (click to Toggle $iif(%Clock == off,ON,OFF) $+ ):.clockswitch
}
#tomtimerautostart on
on 1:start:{
  .timerscrollg -o 0 1 timeg 
  .set -e %tomtimerscroll ok
  .set -e %Clock On
  .set -e %AutoClock On
}
#tomtimerautostart end
on 1:exit:{
  .timescroller 
  unset %tomtimerscroll
}
; ## The next line is the time shown in the clock, you can config it your way
; ## do /help $time and then scroll up in the help file and you will see the parameters 
; ## that will work in this line that you can use $time((ht) HH:nn:ss ddd dd mmm yyyy)
; ## Leave the one in the line above as a backup in case you need to start over
; ## don't mess with the rest of the line, only the $time part
alias -l timeg { timescroller $time((ht) HH:nn:ss ddd dd mmm yyyy)  }

alias -l clockswitch {
  if ((stop isin %tomtimerscroll) || (%tomtimerscroll == $null)) { 
    .timerscrollg -o 0 1 timeg 
    .set -e %tomtimerscroll ok
    .set -e %Clock On
  }
  else {
    if (ok isin %tomtimerscroll) {
      .timerscrollg off 
      .timescroller 
      .set -e %tomtimerscroll stop
      .set -e %Clock Off
    }
  }
}
alias -l toggleclockswitch {

  if ($group(#tomtimerautostart) == off) {

    .enable #tomtimerautostart
    set -e %AutoClock On
  }
  else {
    .disable #tomtimerautostart
    set -e %AutoClock Off
  }
}



alias -l Clock.Scroller.Bounce { return $true }
; ^ Scroll continuously, or bounce back and forth?

alias -l Clock.Scroller.Increment { return -1 }
; ^ How far to scroll (in pixels) for each scrolling update
; -- Negative amount: Begin by scrolling left
; -- Positive amount: Begin by scrolling right

alias -l Clock.Scroller.Milliseconds { return 80 }
; ^ How many milliseconds between animation updates
; -- Use a value no less than 30

alias -l Clock.Scroller.WidthLimit { return 256 }
alias -l Clock.Scroller.HeightLimit { return 256 }
; ^ Maximum toolbar width and height in pixels
; -- (Minimum 16 pixels, maximum 256 pixels)

alias -l Clock.Scroller.Margin { return 6 }
; ^ Margin on the left and right side of the toolbar button

alias -l Clock.Scroller.Spacing { return 12 }
; ^ Extra space between loops

alias -l Clock.Scroller.BackgroundColor { return 12 }
; ^ Toolbar background color

alias -l Clock.Scroller.Font { return "Arial" }
; ^ Font for text. e.g. "Arial" "Arial Rounded MT Bold" "Comic Sans MS" "Times New Roman" "Verdana" ect.
alias -l Clock.Scroller.FontSize { return 14 }
; ^ Font size
alias -l Clock.Scroller.TextColor { return 8 }
; ^ "Base" color for font (ctrl-K/I/B codes can change colors within the string)

alias -l Clock.Scroller.Tooltip { return "Clock" }
; ^ Tooltip for the toolbar button

; --------- Alias

alias TimeScroller {
  ; TimeScroller methods to toggle bouncing and scroll direction
  if ($isid) && ($prop) {
    if ($prop == reverse) {
      if (%Clock.Scroller.ScrollLeft) { set -e %Clock.Scroller.ScrollLeft $false }
      else { set -e %Clock.Scroller.ScrollLeft $true }
    }
    if ($prop == bounce) { 
      if (%Clock.Scroller.Bounce) { set -e %Clock.Scroller.Bounce $false }
      else { set -e %Clock.Scroller.Bounce $true }
    }
    return
  }

  Clock.Scroller.Stop

  ; Use /TimeScroller with no parameter to turn off the scroll and remove the button
  if (!$1) { return }

  set -e %Clock.Scroller.String $1-
  set -e %Clock.Scroller.Position 0

  ; Draw Text in Toolbar, and begin scrolling if too large to fit
  if ($Clock.Scroller.DrawText(%Clock.Scroller.Position)) {
    if (!$toolbar) {
      set -e %Clock.Scroller.ToolBarOff $true
      .toolbar on
    }
    set -e %Clock.Scroller.Increment $abs($Clock.Scroller.Increment)
    set -e %Clock.Scroller.ScrollLeft $iif($Clock.Scroller.Increment > 0,$false,$true)
    set -e %Clock.Scroller.Bounce $Clock.Scroller.Bounce

    .timerClock.Scroller.Update -mo 0 $iif($Clock.Scroller.Milliseconds isnum 30-3000,$v1,80) Clock.Scroller.Move 
  }
}

; -------- Drawing Alias

alias -l Clock.Scroller.DrawText {
  var %pos $1
  var %text $iif($2,$2-,%Clock.Scroller.String) $+ $chr(160)
  var %bneedstoscroll $false

  ; ---- Determine text size
  var %textwidth $width(%text,$Clock.Scroller.Font,$Clock.Scroller.FontSize,0,1)
  var %textheight $height(%text,$Clock.Scroller.Font,$Clock.Scroller.FontSize)

  ; ---- Create picture window as a drawing buffer for the toolbar
  var %margin $Clock.Scroller.Margin
  var %viewheight $iif(%textheight > $Clock.Scroller.SizeLimit($Clock.Scroller.HeightLimit),$Clock.Scroller.SizeLimit($Clock.Scroller.HeightLimit),%textheight)
  var %toolbarheight = %viewheight 

  if ($calc(%textwidth + (%margin * 2)) <= $Clock.Scroller.SizeLimit($Clock.Scroller.WidthLimit)) {
    ; Text is short enough to fit without scrolling
    var %viewwidth %textwidth
    var %toolbarwidth $v1
  }
  else {
    ; Text is too long, we need to scroll
    var %viewwidth %textwidth
    dec %viewwidth %margin
    dec %viewwidth %margin
    var %toolbarwidth $Clock.Scroller.SizeLimit($Clock.Scroller.WidthLimit)

    %bneedstoscroll = $true
  }

  ; Enforce picture window limits
  %toolbarheight = $Clock.Scroller.SizeLimit(%toolbarheight)
  %toolbarwidth = $Clock.Scroller.SizeLimit(%toolbarwidth)

  if (!$window($Clock.Scroller.ToolbarBuffer)) { 
    window -hp +d $Clock.Scroller.ToolbarBuffer 64 64 $calc(%toolbarwidth + $Clock.Scroller.BorderSize) $calc(%toolbarheight + $Clock.Scroller.BorderSize)
  }

  ; ---- Draw
  ; Clear 
  drawfill -n $Clock.Scroller.ToolbarBuffer $Clock.Scroller.BackgroundColor $Clock.Scroller.Drawsize 0 0

  ; Draw Text
  var %textpos $calc(%margin + $Clock.Scroller.XOffset + %pos)
  drawtext -npb $Clock.Scroller.ToolbarBuffer $Clock.Scroller.TextColor $Clock.Scroller.BackgroundColor $Clock.Scroller.Font $Clock.Scroller.FontSize $calc(%textpos + $Clock.Scroller.XOffset) $Clock.Scroller.YOffset %text

  ; Draw second copy of text if continuously looping
  if (!%Clock.Scroller.Bounce) {
    if (%textpos > %margin) {
      dec %textpos %textwidth
      dec %textpos $Clock.Scroller.Spacing
    }
    else {
      inc %textpos %textwidth
      inc %textpos $Clock.Scroller.Spacing
    }
    drawtext -npb $Clock.Scroller.ToolbarBuffer $Clock.Scroller.TextColor $Clock.Scroller.BackgroundColor $Clock.Scroller.Font $Clock.Scroller.FontSize %textpos $Clock.Scroller.YOffset %text
  }

  ; Clear Margins
  drawrect -nf $Clock.Scroller.ToolbarBuffer $Clock.Scroller.BackgroundColor $Clock.Scroller.Drawsize 0 0 %margin %toolbarheight
  drawrect -nf $Clock.Scroller.ToolbarBuffer $Clock.Scroller.BackgroundColor $Clock.Scroller.Drawsize $calc(%toolbarwidth - %margin) 0 %margin %toolbarheight

  ; ---- Blt surface to toolbar
  if (!$toolbar($Clock.Scroller.ToolbarName)) {
    toolbar -ax $Clock.Scroller.ToolbarName $Clock.Scroller.Tooltip $Clock.Scroller.ToolbarBuffer 0 0 %toolbarwidth %toolbarheight /Clock.Scroller.Click
  }
  else {
    toolbar -p $Kin.Scroller.ToolbarName $Clock.Scroller.ToolbarBuffer 0 0 %toolbarwidth %toolbarheight
  }

  if ($isid) { return %bneedstoscroll }
}

; -------- Support Aliases

alias -l Clock.Scroller.SizeLimit {
  ; mIRC limits on the size of picture windows for use with the toolbar
  if ($1 < 16) { return 16 }
  elseif ($1 > 256) { return 256 }
  elseif ($1 !isnum) { return 36 }
  else { return $1 }
}

alias -l Clock.Scroller.Move {
  var %pos $iif(%Clock.Scroller.Position,$v1,0)
  var %inc $iif(%Clock.Scroller.Increment,$v1,$Clock.Scroller.Increment)
  var %left %Clock.Scroller.ScrollLeft
  var %bbounce %Clock.Scroller.Bounce

  var %max $width(%Clock.Scroller.String,$Clock.Scroller.Font,$Clock.Scroller.FontSize,0,1)
  inc %max $Clock.Scroller.MatchupOffset

  ; Move
  if (%left) { dec %pos %inc }
  else { inc %pos %inc }

  ; Continuous scrolling
  if (!%bbounce) {
    ; The second loop of text needs spacing
    inc %max $Clock.Scroller.Spacing

    ; Loop
    if (%pos < 0) || (%pos >= %max) {
      %pos = $calc( (%max + (%pos % %max)) % %max)
    }
  }
  ; Bouncing motion
  else {
    ; How much hidden text is there when bouncing between left and right
    dec %max $Clock.Scroller.SizeLimit($Clock.Scroller.WidthLimit)
    inc %max $Clock.Scroller.Margin
    inc %max $Clock.Scroller.Margin

    ; Bounce
    if (%pos < $calc(0 - %max)) || (%pos >= 0) {
      noop $Scroller().reverse
      %pos = $calc(0 - (%max + (%pos % %max)) % %max))
    }
  }

  Clock.Scroller.DrawText %pos
  set -e %Clock.Scroller.Position %pos
}

alias -l Clock.Scroller.Stop {
  ; Clear previous buffer and button
  if ($window($Clock.Scroller.ToolbarBuffer)) { window -c $Clock.Scroller.ToolbarBuffer }
  if ($toolbar($Clock.Scroller.ToolbarName)) { toolbar -d $Clock.Scroller.ToolbarName }
  if (%Clock.Scroller.ToolBarOff) { .toolbar off } 
  .timerClock.Scroller.Update off
  unset %Clock.Scroller.*
}

alias -l Clock.Scroller.Click {
  ; Switch the direction of the scroll when the toolbar is clicked
  noop $scroller().reverse
}

; -------- Support Configuration

alias Clock.Scroller.Drawsize { return 1 }
alias Clock.Scroller.YOffset { return -2 }
alias Clock.Scroller.XOffset { return 2 }
alias Clock.Scroller.MatchupOffset { return 5 }
alias Clock.Scroller.BorderSize { return 2 }

alias Clock.Scroller.ToolbarName { return Clock.Scroller }
alias Clock.Scroller.ToolbarBuffer { return @Clock.Scroller.TempBuffer }
