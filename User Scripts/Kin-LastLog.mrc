; Kin's Last Log
; Hosted at https://github.com/Th3GrimRipp3r/ReaperCon

; 2013-05-22 v1.2 Add popup menus
; 2012-05-05 v1.1 Force font on window
; 2011-08-03 v1.0

; ---- User Commands

alias ll { Kin.LastLog literal $$1- }
alias llregex { Kin.LastLog regex $$1- }

; ---- Popup Menu

menu nicklist {
  Kin's Last Log
  .Search for " $+ $$1 $+ " on $active:ll $$1
  .Search for $$1 exhaustively on $active (no word boundaries):llregex $+((?i),\Q,$$1,\E)
  .-
}

menu * {
  Kin's Last Log
  .Input string to search on $active:ll $input(Enter search string. $crlf $crlf Limited to word bounded results. $crlf "cat" will not return "category",eoi,Kin's Last Log)
  .Input string to search exhaustively on $active (no word boundaries):llregex $+((?i),\Q,$input(Enter search string. $crlf $crlf Includes results that are not word bounded. $crlf "kin" will not return "kinny",eoi,Kin's Last Log),\E)
  .Input RegEx pattern to search on $active:llregex $input(Enter RegEx search pattern. $crlf $crlf An example case insensitive search for the literal string "Kin": $crlf $+($chr(40),?i,$chr(41),\b\QKin\E\b),eoi,Kin's Last Log)
}

; ---- Alias

alias -l Kin.LastLog {
  ; Last Log 
  ; KinKinnyKith 2011-08-03
  ; irc.geekshed.net #ReaperCon
  ; Copies all lines that match an input wholeword (nickname / hostmask) from the active channel window to an output window
  ; Example Usage:
  ;   /ll Kin
  ;   /ll protectedhost-12345678.dsl.wlfrct.sbcglobal.net

  ; Grab active window in case it changes
  var %SourceWindow $active
  var %DestWindow $+(@LastLog.,$$2)

  ; Open new window, make active, and clear if it exists
  /window -e %DestWindow
  ; Alternatively, open window with a specific size
  ; /window -e %DestWindow 0 0 1306 526
  ; Alternatively, open window and do not make active
  ; /window -n %DestWindow

  ; Optionally force a font and size to the output window
  ; /font %DestWindow 19 Arial

  ; /clear also slows down moving on to /filter, which requires the window to be fully rendered before it will function
  /clear %DestWindow

  var %pattern $$2-
  if ($1 != regex) {
    %pattern = $+((?i),\b\Q,%pattern,\E\b)
  }

  ; The following copies matching lines while preserving colors, ignores formatting codes for the match, wraps text, includes the source line number, and is -not- case sensitive:
  if (%SourceWindow == Status Window) {
    /filter -swwgczbpn %DestWindow %pattern
  }
  else {
    /filter -wwgczbpn %SourceWindow %DestWindow %pattern
  }
}
