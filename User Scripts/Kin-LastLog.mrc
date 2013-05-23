; Kin's Last Log
; Hosted at https://github.com/Th3GrimRipp3r/ReaperCon

; 2012-05-23 v1.4 Include original search string/pattern to the top of the result window
; 2012-05-22 v1.3 Added a command to simultaneously search for alternate strings, e.g. /lll kin|1A2B3C4D|topic|kicked
; 2012-05-22 v1.2 Add popup menus
; 2012-05-05 v1.1 Force font on window
; 2011-08-03 v1.0

; ---- User Commands

alias ll { Kin.LastLog wordbounded $$1- }
alias lll { Kin.LastLog alternations $$1- }
alias llregex { Kin.LastLog regex $$1- }

; ---- Popup Menu

menu nicklist {
  Kin's Last Log
  .Search for " $+ $$1 $+ " on $active:Kin.LastLog wordbounded $$1
  .Search for $$1 exhaustively on $active (no word boundaries):Kin.LastLog literal $$1
  .-
}

menu * {
  Kin's Last Log
  .Input string to search on $active:Kin.LastLog wordbounded $input(Enter search string. $crlf $crlf Limited to word bounded results. $crlf "cat" will not return "category",eoi,Kin's Last Log)
  .Input string to search exhaustively on $active (no word boundaries):Kin.LastLog literal $input(Enter search string. $crlf $crlf Includes results that are not word bounded. $crlf "kin" will not return "kinny",eoi,Kin's Last Log)
  .Input RegEx pattern to search on $active:Kin.LastLog regex $input(Enter RegEx search pattern. $crlf $crlf An example case insensitive search for the literal string "Kin": $crlf $+($chr(40),?i,$chr(41),\b\QKin\E\b),eoi,Kin's Last Log)
}

; ---- Alias

alias -l Kin.LastLog {
  if (!$2) { return }

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
  if ($1 == wordbounded) {
    %pattern = $+((?i),\b\Q,%pattern,\E\b)
  }
  elseif ($1 == literal) {
    %pattern = $+((?i),\Q,%pattern,\E)
  }
  elseif ($1 == alternations) {
    var %out
    var %altmax $numtok(%pattern,124)
    var %altix 1
    while (%altix <= %altmax) {
      %out = $addtok(%out,$+(\Q,$gettok(%pattern,%altix,124),\E),124)
      inc %altix 
    }
    %pattern = $+((?i),\b,$chr(40),%out,$chr(41),\b)
  }
  elseif ($1 != regex) {
    %pattern = $+((?i),\b\Q,%pattern,\E\b)
  }

  var %colorpattern %pattern
  ; Style in-line regex flags
  %colorpattern = $regsubex(%colorpattern,/(\(\?\w+\))/,$+($chr(3),14,\1,$chr(15)))
  ; Style original input pattern separately from added pattern modifications
  %colorpattern = $regsubex(%colorpattern,/(\Q $+ $2- $+ \E)/,$+($chr(31),$chr(3),07,\1,$chr(15)))
  ; Include original search pattern at the top of the result window
  echo %DestWindow $+($chr(3),03,(Kin-LastLog),$chr(15)) Search pattern: %colorpattern 
  echo %DestWindow $chr(160)

  ; The following copies matching lines while preserving colors, ignores formatting codes for the match, wraps text, includes the source line number, and is -not- case sensitive:
  if (%SourceWindow == Status Window) {
    /filter -swwgzbpn %DestWindow %pattern
  }
  else {
    /filter -wwgzbpn %SourceWindow %DestWindow %pattern
  }
}
