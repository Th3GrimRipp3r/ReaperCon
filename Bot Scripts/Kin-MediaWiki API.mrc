; ----------------------------------------------------------------
; Kin's mSL MediaWiki API Interface - mIRC Wiki Bot and Activity Feed
; KinKinnyKith - Kin "Kinny" Kith
; #ReaperCon #mIRC #Script-Help #Bots - IRC.GeekShed.Net
; http://code.google.com/p/reapercon/
; 2012-02-16
; v2.4 Alpha Debug Version
; ----------------------------------------------------------------
; Command Line Debug Usage
;  > //noop $Wiki.API(en.wikipedia.org,/w/api.php).RecentChanges
;  > //noop $Wiki.API(User,Password,www.wikidomain.com,/wiki/api.php).Login
; or
;  > /Wiki.API Login User Password www.wikidomain.com /wiki/api.php
; Bot Usage
;  > !wiki help
; ----------------------------------------------------------------
; mSL socket with auth and cookie handling to interface with the
;  MediaWiki API.
; Feed any MediaWiki Wiki's recent changes and abuse filter log in your
;  channel.  Perform edit and log search tasks from within IRC.
; Execute restricted actions such as block users, delete articles,
;  and view restricted abuse filter data with auto-login.
; ----------------------------------------------------------------
; Features:
;  )Recent Changes Feed in channel with diff link
;  )Edit or search articles from channel
;  )Login to Wiki with Bot permissions for higher rate limit queries
;  )Abuse Filter Feed in channel with ip address of user's offense
;  )Administrative functions: block users, ip addresses, delete spam
; ----------------------------------------------------------------
; To-Do
;  )Everything 8D
; Working:
;  )Socket
;  )Cookies
;  )Login / Auth / Token
;  )Logout
;  )Recent Changes (but not freeing hashes)
; ----------------------------------------------------------------

; -------- Debugging Identifiers ---------------------------------
; ---- Add return | to disable debug reporting
;alias -l Wiki.API.Debug { return | Wiki.API.Report $1- }
alias -l Wiki.API.Debug { Wiki.API.Report $1- }
alias -l Wiki.API.Debug.Hash { Wiki.API.Report $1- }
; ---- Uncomment this line to disable socket
;alias -l Wiki.API.Offline { return Wiki.API.Report Offline-> }
; -------- Customization Identifiers -----------------------------
alias -l Wiki.API.Version { return 2.4 Alpha Debug }
alias -l Wiki.API.Timeout { return 8 }
alias -l Wiki.API.Tag { return $timestamp MediaWiki API = }
alias -l Wiki.API.Link.Diff { return $+(http://,$Wiki.API.Hash(Wiki.API.Info,Host).get,/wiki/?diff=,$1) }
;alias -l Wiki.API.Link.File { return $+() }
; -------- Reporting ---------------------------------------------
alias -l Wiki.API.Report { if (!$window(@Wiki.API)) { /window -ne2 @Wiki.API | /log on @Wiki.API -f \logs\ $+ @Wiki.API $+ .log } | !echo @Wiki.API $Wiki.API.Tag $1- }
; -------- Interface Alias ---------------------------------------
on *:EXIT: { Wiki.API.Hash Wiki.API.Info clear | Wiki.API.Hash Wiki.API.Cookies clear }
alias Wiki.API {
  if ($prop == ClearCookies) { Wiki.API.Hash Wiki.API.Cookies clear }
  elseif ($prop == SetUser) { Wiki.API.Hash Wiki.API.Info add User $1 }
  elseif ($prop == SetPassword) { Wiki.API.Hash Wiki.API.Info add Password $1 }
  elseif ($prop == SetHost) { Wiki.API.Hash Wiki.API.Info add Host $1 }
  elseif ($prop == SetPath) { Wiki.API.Hash Wiki.API.Info add Path $1 }
  elseif (($prop == Login) || ($prop == SendToken)) {
    if ($prop == Login) {
      ; ---- Set Login Parameters
      Wiki.API.Debug Login - $1-
      if (!$5) { Wiki.API.Hash Wiki.API.Cookies clear }
      else { Wiki.API.Hash Wiki.API.Info add Token $4 }
      if ($4) { Wiki.API.Hash Wiki.API.Info add Path $4 }
      if ($3) { Wiki.API.Hash Wiki.API.Info add Host $3 }
      if ($2) { Wiki.API.Hash Wiki.API.Info add Password $2 }
      if ($1) { Wiki.API.Hash Wiki.API.Info add User $1 }
    }
    else {
      ; ---- Set Token and Reuse Login Parameters
      if ($1) { Wiki.API.Hash Wiki.API.Info add Token $1 }
      else { Wiki.API.Report $prop 4Failed Missing Token }
    }
    ; ---- Get Login Parameters
    var %keys User,Password,Host,Path
    var %mark, %dat, %key, %ib 1, %ix $numtok(%keys,44)
    Wiki.API.Debug $prop - Keys - %keys
    while (%ib <= %ix) {
      %key = $gettok(%keys,%ib,44)
      %dat = $Wiki.API.Hash(Wiki.API.Info,%key).get
      if (!%dat) { Wiki.API.Report $prop - Missing - %key | %mark = $null | break }
      %mark = %mark %dat
      var % [ $+ [ %key ] ] %dat
      inc %ib
    }
    if (!%mark) { Wiki.API.Report $prop 4Failed | return }
    var %token $Wiki.API.Hash(Wiki.API.Info,token).get
    Wiki.API.Debug $prop - Login Args - %mark $iif(%token,$v1)
    ; ---- Login Socket
    Wiki.API.Sock.Open Wiki.API.Login %host $+(%path,?,$Wiki.API.Request(%user,%password,%token).Login)
  }
  elseif ($prop == Logout) {
    Wiki.API.Sock.Open Wiki.API.Logout $Wiki.API.Hash(Wiki.API.Info,host).get $+($Wiki.API.Hash(Wiki.API.Info,path).get,?,$Wiki.API.Request().Logout)
  }
  elseif ($prop == RecentChanges) {
    Wiki.API.Hash Wiki.API.Cookies clear
    if ($2) { Wiki.API.Hash Wiki.API.Info add Path $2 }
    if ($1) { Wiki.API.Hash Wiki.API.Info add Host $1 }
    Wiki.API.Sock.Open Wiki.API.RecentChanges $Wiki.API.Hash(Wiki.API.Info,host).get $+($Wiki.API.Hash(Wiki.API.Info,path).get,?,$Wiki.API.Request().RecentChanges)
  }
  else {
    Wiki.API.Hash Wiki.API.Cookies clear
    if ($2) { Wiki.API.Hash Wiki.API.Info add Path $2 }
    if ($1) { Wiki.API.Hash Wiki.API.Info add Host $1 }
    Wiki.API.Sock.Open Wiki.API.Other $Wiki.API.Hash(Wiki.API.Info,host).get $+($Wiki.API.Hash(Wiki.API.Info,path).get,?,$Wiki.API.Request(). [ $+ [ $prop ] ] )
  }
}
; -------- API Strings -------------------------------------------
alias -l Wiki.API.Request {
  var %req
  if ($prop == Login) { %req = $+(action=login&lgname=,$UrlEncode($1),&lgpassword=,$UrlEncode($2),&format=xml,$iif($3,&lgtoken= $+ $3)) }
  elseif ($prop == Logout) { %req = action=logout&format=xml }
  elseif ($prop == RecentChanges) {
    %req = $+(action=query&list=recentchanges&format=xml&rcprop=,$UrlEncode(user|userid|comment|parsedcomment|flags|timestamp|title|ids|sizes|redirect|loginfo|tags),&rctype=,$UrlEncode(edit|new|log),&rclimit=8)
  }
  elseif ($prop == adminedits) { %req = action=query&list=allusers&augroup=sysop&auprop=editcount&aulimit=20&format=xml }
  elseif ($prop == user) { %req = action=query&list=users&augroup=sysop&auprop=blockinfo&format=xml }
  elseif ($prop == blocks) { %req = action=query&list=blocks&bkusers=&bkip=&augroup=sysop&auprop=blockinfo&format=xml }
  elseif ($prop == abuse) { %req = $+(action=query&list=abuselog&afllimit=4&aflprop=,$UrlEncode(ids|filter|user|action|result|timestamp),&format=xml) }
  elseif ($prop == abuseadmin) { %req = $+(action=query&list=abuselog&afllimit=4&aflprop=,$UrlEncode(ids|filter|user|ip|action|result|timestamp),&format=xml) }
  ;elseif ($prop == abuseip) { %req = action=query&list=abuselog&afllimit=4&afluser123.123.123.123&format=xml }
  Wiki.API.Debug Wiki.API.Request - $prop - %req
  return %req
}
; -------- Socket ------------------------------------------------
alias -l Wiki.API.Sock.Error { Wiki.API.Report 4Socket Error - $1- ErrNum: $sock($1-).wserr Message: $sock($1-).wsmsg | Wiki.API.Sock.Close $1- }
alias -l Wiki.API.Sock.Timeout { Wiki.API.Report 4Socket Timeout - $1- | Wiki.API.Sock.Close $1- }
alias -l Wiki.API.Sock.Close { Wiki.API.Debug Socket Close - $1- | noop $Wiki.API.Timer($1-,Timeout).off | .sockclose $1- }
alias Wiki.API.Sock.Open {
  var %sock $1, %host $2, %path $3
  Wiki.API.Debug Wiki.API.Sock.Open - %sock - %host - %path
  sockclose %sock
  unset % $+ [ %sock ] $+ *
  Wiki.API.Hash %sock clear
  Wiki.API.Hash %sock add Socket.Host %host
  Wiki.API.Hash %sock add Socket.Path %path
  Wiki.API.Hash %sock add Socket.In 0
  Wiki.API.Hash %sock add Socket.Out 0
  noop $Wiki.API.Timer(%sock,Timeout,Wiki.API.Sock.Timeout %sock).on
  sockopen %sock %host 80
  if ($sockerr) { Wiki.API.Sock.Error $sock | return }
  sockmark %sock %host %path
}
on *:SOCKOPEN:Wiki.API*: {
  Wiki.API.Debug Socket 3Open - $sockname
  if ($sockerr) { Wiki.API.Sock.Error $sockname | return }
  Wiki.API.Debug Socket Mark - $sock($sockname).mark
  var %host $gettok($sock($sockname).mark,1,32), %path $gettok($sock($sockname).mark,2,32), %dat $gettok($sock($sockname).mark,3-,32)
  $iif($Wiki.API.Offline,Wiki.API.Report Offline->) sockwrite -n $sockname POST %path HTTP/1.1
  [ $Wiki.API.Offline ] sockwrite -n $sockname Host: %host
  [ $Wiki.API.Offline ] sockwrite -n $sockname User-Agent: mIRC/ $+ $version (Windows $os $bits $+ ; en) Kin-MediaWiki-API/ $+ $Wiki.API.Version (Kin's mSL MediaWiki API IRC Interface;)
  var %cookies $Wiki.API.Hash(Wiki.API.Cookies).getall
  if (%cookies) { [ $Wiki.API.Offline ] sockwrite -n $sockname Cookie: %cookies }
  ; if (%dat){ [ $Wiki.API.Offline ] sockwrite -n $sockname Content-Length: $len(%dat) }
  ; if (%dat){ [ $Wiki.API.Offline ] sockwrite -n $sockname Content-Type: application/x-www-form-urlencoded }
  [ $Wiki.API.Offline ] sockwrite -n $sockname $crlf
  ; if (%dat){ [ $Wiki.API.Offline ] sockwrite -n $sockname $crlf %dat } | else { [ $Wiki.API.Offline ] sockwrite -n $sockname $crlf }
}
on *:SOCKREAD:Wiki.API*: {
  if ($sockerr) { Wiki.API.Sock.Error $sockname }
  var %Content $Wiki.API.Hash($sockname,HTTP.Content).get
  if (!%Content) {
    Wiki.API.Debug $sockname - 11SockRead - Header
    var %r, %Response $Wiki.API.Hash($sockname,HTTP.Response).get
    while ($sock($sockname).rq) {
      sockread %r | if ($sockerr) { Wiki.API.Sock.Error $sockname | return }
      if (!%Response) { Wiki.API.Debug $sockname - HTTP Response 4==> %r | noop $Wiki.API.Timer($sockname,Timeout).off | %Response = %r | Wiki.API.Hash $sockname add HTTP.Response %Response | continue }
      Wiki.API.Debug $sockname - HTTP Header 7==> %r
      if ($regex(%r,/^Set-Cookie:\s*([^=]+)=([^;]+);/i)) { Wiki.API.Hash Wiki.API.Cookies add $regml(1) $regml(2) | Wiki.API.Debug $sockname - Cookie - %r }
      if ($regex(%r,/^Content-Type:\stext\/(xml|html);\scharset=utf-8/i)) { %Content = $regml(1) | Wiki.API.Hash $sockname add HTTP.Content %Content | Wiki.API.Debug $sockname - Content $+(8,%Content,) - %r | break } 
    }
  }
  Wiki.API.Debug $sockname - 11SockRead - Post Header
  if (%Content) {
    var %bDat, %overflow
    while ($sock($sockname).rq) {
      Wiki.API.Debug $sockname - Content Read Queue - $sock($sockname).rq - Sock BVar Length: $bvar(&br,0)
      sockread -fn $sock($sockname).rq &br | if ($sockerr) { Wiki.API.Sock.Error $sockname | return }
      %bDat = &br
      ; ---- Manage Socket Overflow
      %overflow = $Wiki.API.Hash($sockname,Socket.Overflow).pull
      if (%overflow) {
        Wiki.API.Debug $sockname - 3Overflow Get - Len: $len(%overflow) - Dat: %overflow
        bset -t &bnew 1 %overflow
        bcopy &bnew $calc($bvar(&bnew,0) + 1) %bDat 1 -1
        %bDat = &bnew
        bunset &br
        %overflow = $null
      }
      ; ---- Socket Data
      if (%Content == xml) {
        %overflow = $Wiki.API.Tags2Hash($sockname,%bDat)
        Wiki.API.Update $sockname
      }
      else { Wiki.API.Debug $sockname - 11SockRead - Closing... | Wiki.API.Sock.Close $sockname }
      ; ---- Manage Socket Overflow
      if (%overflow) { Wiki.API.Hash $sockname add Socket.Overflow %overflow | Wiki.API.Debug $sockname - 3Overflow Set - Len: $len(%overflow) - Dat: %overflow }
    }
  }
  Wiki.API.Debug $sockname - 11SockRead - Retrigger
}
on *:SOCKCLOSE:Wiki.API*: { Wiki.API.Sock.Close $sockname }
; -------- API Result Processing ---------------------------------
alias -l Wiki.API.Tags2Hash {
  ;Wiki.API.Debug.Hash Wiki.API.Tag2Hash $1-
  var %hname $1, %bv $2
  var %b 1, %s 1, %e 1, %m $bvar(%bv,0), %l
  %s = $bfind(%bv,%b,60) | %e = $bfind(%bv,%b,62)
  ;Wiki.API.Debug.Hash Wiki.API.Tag2Hash B %b S %s E %e L %l M %m
  while ((%s > 0) && (%e > 0) && (%s <= %m)) {
    if (%s > %e) { inc %e | Wiki.API.Debug Wiki.API.Tag2Hash 5Broken Previous Tag - Text: $bvar(%bv,%b,$calc(%e - %b)).text | %s = %e | %b = %s }
    else {
      if (%s > %b) { 
        var %in $Wiki.API.Hash(%hname,Socket.In).get | inc %in | Wiki.API.Hash %hname add %in $bvar(%bv,%b,$calc(%s - %b)).text | Wiki.API.Hash %hname add Socket.In %in
        Wiki.API.Debug Wiki.API.Tag2Hash 3Untagged Data - Text: $bvar(%bv,%b,$calc(%s - %b)).text
      }
      inc %e | %l = $calc(%e - %s)
      var %in $Wiki.API.Hash(%hname,Socket.In).get | inc %in | Wiki.API.Hash %hname add %in $bvar(%bv,%s,%l).text | Wiki.API.Hash %hname add Socket.In %in
      %s = %e | %b = %s
    }
    %s = $bfind(%bv,%b,60) | %e = $bfind(%bv,%b,62)
    ;Wiki.API.Debug.Hash Wiki.API.Tag2Hash B %b S %s E %e L %l M %m
  }
  ;Wiki.API.Debug.Hash Wiki.API.Tag2Hash Stat - B %b S %s E %e L %l M %m
  ; ---- Overflow
  if (%b <= %m) { return $bvar(%bv,%b, $calc(%m - %b + 1)).text }
}
alias -l Wiki.API.Update {
  if (!$1) { return }
  var %hname $1, %in, %out, %line, %state, %p, %dat, %outhash
  Wiki.API.Debug %hname - 7Update --> $1-
  %in = $Wiki.API.Hash(%hname,Socket.In).get | %out = $Wiki.API.Hash(%hname,Socket.Out).get | %state = $Wiki.API.Hash(%hname,Result.State).get 
  if (%out < 1) { %out = 1 }
  while (%out <= %in) {
    %line = $Wiki.API.Hash(%hname,%out).get
    %state = %state $+ %line
    Wiki.API.Debug %hname - 14Found Line --> State: %state Line: %line
    ; ---- Recent Changes
    %p = /(.*?<api><query><recentchanges>)(<rc\s[^>]+>.*?<\/rc>)(.*)/
    if ($regex(%state,%p)) {
      %dat = $regml(2)
      %state = $regml(1) $+ $regml(3)
      Wiki.API.Debug %hname - 4Found Match %dat
      %outhash = $XML2Hash($+(%hname,.,%out),%dat)
      DatBoundTags2Hash %outhash %dat
      Wiki.API.Output %outhash
    }
    ; ---- Recent Changes Continue
    %p = /(.*?)<api><query><recentchanges></recentchanges></query><query-continue>(<recentchanges\s[^>]+\s\/>)</query-continue>(.*)/
    if ($regex(%state,%p)) {
      %dat = $regml(2)
      %state = $regml(1) $+ $regml(3)
      Wiki.API.Debug %hname - 4Found Continue %dat
    }
    ; ---- Login / Token / Success
    %p = /(.*?)<api>(<login\s[^>]+\s\/>)</api>(.*)/
    if ($regex(%state,%p)) {
      %dat = $regml(2)
      %state = $regml(1) $+ $regml(3)
      Wiki.API.Debug %hname - 4Login Need Token %dat
      ;%outhash = $XML2Hash($+(%hname,.,Login),%dat)
      %outhash = $XML2Hash(%hname,%dat)
      if ($Wiki.API.Hash(%outhash,result).get == NeedToken) {
        Wiki.API.Sock.Close $1
        Wiki.API.Report 7Login Token Received 4>> Sending Token Back
        var %tok $Wiki.API.Hash(%outhash,token).get
        noop $Wiki.API.Hash(%outhash).clear
        noop $Wiki.API(%tok).SendToken
        return
      }
      if ($Wiki.API.Hash(%outhash,result).get == Success) {
        Wiki.API.Sock.Close $1
        Wiki.API.Report 7Successfully Logged In 4>> Logging Out Now
        noop $Wiki.API().Logout
        noop $Wiki.API.Hash(%outhash).clear
        return
      }
    }
    ; ---- Logout
    %p = /<\?xml\sversion="1\.0"\?><api\s\/>/
    if ($regex(%state,%p)) { Wiki.API.Report 7Successfully Logged Out | noop $Wiki.API.Hash($1).clear | return }
    inc %out
  }
  Wiki.API.Hash %hname add Result.State %state
  Wiki.API.Hash %hname add Socket.Out %out
}
alias -l Wiki.API.Output {
  if (!$1) { return }
  Wiki.API.Debug %hname - 7Output --> $1-
  var %hname $1, %strOutput, %tag $Wiki.API.Hash(%hname,Tag).get, %type $Wiki.API.Hash(%hname,type).get, %comment $Wiki.API.Hash(%hname,parsedcomment).get
  if (%tag == rc) {
    if ($Wiki.API.Hash(%hname,user).get) { %strOutput = %strOutput $+(14,$v1,) }
    if (%type == edit) { %strOutput = %strOutput edited }
    if (%type == log) { if ($Wiki.API.Hash(%hname,logaction).get = upload) { %strOutput = %strOutput uploaded } }
    if ($Wiki.API.Hash(%hname,title).get) { %strOutput = %strOutput $+(14,$v1,) }
    if (%type == edit) {
      ; Size
      if ($Wiki.API.Hash(%hname,newlen).get == 0) { %strOutput = %strOutput $+(5,$chr(40),blanked!,$chr(41),) }
      elseif ($Wiki.API.Hash(%hname,oldlen).get > $Wiki.API.Hash(%hname,newlen).get) { %strOutput = %strOutput $+(7,$chr(40),$calc($v2 - $v1),$chr(41),) }
      else { %strOutput = %strOutput $+(15,$chr(40),+,$calc($v2 - $v1),$chr(41),) }
    }
    if (%type == edit) { if ($Wiki.API.Hash(%hname,revid).get > 0) { %strOutput = %strOutput $Wiki.API.Link.Diff($v1) } }
    if ($Wiki.API.Hash(%hname,timestamp).get) { %strOutput = %strOutput $+(15,$chr(91),$v1,$chr(93),) }
    if (%comment) {
      %comment = $NoHTML($HTMLEntities(%comment))
      if ($left(%comment,1) == $chr(8594)) { %comment = $right(%comment,-1) | %strOutput = %strOutput 15Section: }
      else { %strOutput = %strOutput $+ 15 }
      %strOutput = %strOutput $+(,$chr(40),%comment,$chr(41),)
    }
  }
  Wiki.API.Report %strOutput
}
; -------- Hash Extensions ---------------------------------------
alias XML2Hash {
  ; regex variations to build a hash from xml like: <rc item="data" item2="data2"><moreparams>data</moreparams></rc>
  var %hname $1, %dat $2-, %tag
  var %pKeyDat /\s([^/><=]+)="([^"]+)"(?=[\s>])/g
  ;var %pItemAll /(<([^\s?<>/]+)\s[^/>=]+="[^"]+"[^>]*[\s>](?:.*?)<\/\2>)/g
  var %pTag /(?:<([^\s?<>/]+)(?=\s[^/>=]+="[^"]+"[\s>])[^>]*>)(?:.*?)<\/\1>/
  ;var %pTagOld /(<([^\s?<>/]+)((?=\s[^/>=]+="[^"]+"[\s>])[^>]*>))(?:.*?)(<\/\2>)/
  ;;var %pTag /<([^\s<>/]+)(?=[^/><=]*\s[^/><=]+="[^"]+"[\s>])/
  ;;var %pOuterAll /(?:<(\w+)>)(?=(?:<\w+>)*<([^\s?<>/]+)\s[^/>=]+="[^"]+"[^>]*[\s>](?:.*?)<\/\2>.*?<\/\1>)/g
  ;;var %pOuterClosest /(?:<(\w+)>)(?=<([^\s?<>/]+)\s[^/>=]+="[^"]+"[^>]*[\s>](?:.*?)<\/\2>.*?<\/\1>)/g
  if ($regex(%dat,%pTag)) { %tag = $regml(1) }
  ;if ($regex(%dat,/<([^\s<>\/]+)/)) { %tag = $regml(1) }
  if (%tag) { %hname = %hname $+ . $+ %tag }
  Wiki.API.Debug XML2Hash - %hname - %dat
  if (!$regex(%dat,%pKeyDat)) { return }
  Wiki.API.Hash.Clear %hname
  Wiki.API.Hash.Make %hname 20
  if (%tag) { Wiki.API.Hash.Add %hname Tag %tag }
  var %ib 1, %io, %ix $regml(0)
  while (%ib <= %ix) {
    %io = %ib
    inc %io
    Wiki.API.Hash.Add %hname $regml(%ib) $HTMLEntities($regml(%io))
    inc %ib 2
  }
  return %hname
}
alias DatBoundTags2Hash {
  ; Add key / dat to hash table from tags like: <key>data</key>
  var %hname $1, %dat $2-, %patTags /<(\w+)>([^<]+)<\/\1>/g
  Wiki.API.Debug DatBoundTags2Hash - %hname - %dat
  if (!$regex(%dat,%patTags)) { return }
  var %ib 1, %io, %ix $regml(0)
  while (%ib <= %ix) {
    %io = %ib
    inc %io
    Wiki.API.Hash.Add %hname $regml(%ib) $HTMLEntities($regml(%io))
    inc %ib 2
  }
  return %hname
}
alias -l JSON2Hash {
  ; var %patternJSON /"([^"]+)":\s*(("([^"]+)"),?|(\d+),))/i
  ; var %patternJSON /"([^"]+)":\s*"([^"]+)"(,)?/i
}
; -------- Hash Tables -------------------------------------------
alias -l Wiki.API.Hash.Clear { if ($hget($1)) { .hfree $1 } | Wiki.API.Debug.Hash Hash Cleared - $1 }
alias -l Wiki.API.Hash.Make { if (!$hget($1)) { .hmake $1 $2 | Wiki.API.Debug.Hash Hash Made - $1 ( $+ $2 $+ ) } }
alias -l Wiki.API.Hash.Add { Wiki.API.Hash.Make $1 8 | hadd $1 $2 $3- | Wiki.API.Debug.Hash Hash Added $1 - $2 => $3- }
alias -l Wiki.API.Hash.Del { if (!$hget($1)) { return } | .hdel $1 $2 | Wiki.API.Debug.Hash Hash del - $1 - $2 }
alias -l Wiki.API.Hash.Get { if (!$hget($1)) { return } | var %dat $hget($1,$2) | Wiki.API.Debug.Hash Hash Got - $1 - $2 => %dat | return %dat }
alias -l Wiki.API.Hash.Pull { if (!$hget($1)) { return } | var %dat $hget($1,$2) | Wiki.API.Hash.Del $1 $2 | Wiki.API.Debug.Hash Hash Pulled - $1 - $2 => %dat | return %dat }
alias -l Wiki.API.Hash.GetAll {
  if (!$hget($1)) { return }
  var %out, %key, %ib 1, %ix $hget($1,0).item
  while (%ib <= %ix) { %key = $hget($1,%ib).item | %out = %out $+(%key,=,$hget($1,%key),;) | inc %ib }
  Wiki.API.Debug.Hash Hash GotAll - $1 - %out
  return %out
}
alias -l Wiki.API.Hash {
  if (!$prop) {
    if ($2 == clear) { Wiki.API.Hash.Clear $1 }
    elseif ($2 == add) { Wiki.API.Hash.Add $1 $3 $4- }
    elseif ($2 == make) { Wiki.API.Hash.Clear $1 | Wiki.API.Hash.Make $1 $3 }
    return
  }
  if ($prop == clear) { Wiki.API.Hash.Clear $1 }
  elseif ($prop == add) { Wiki.API.Hash.Add $1 $2 $3- }
  elseif ($prop == get) { return $Wiki.API.Hash.Get($1,$2) }
  elseif ($prop == pull) { return $Wiki.API.Hash.Pull($1,$2) }
  elseif ($prop == getall) { return $Wiki.API.Hash.GetAll($1-) }
  elseif ($prop == make) { Wiki.API.Hash.Clear $1 | Wiki.API.Hash.Make $1 $2 }
}
; -------- Timer Control -----------------------------------------
alias -l Wiki.API.Timer {
  if (($prop == on) && ($1)) {
    if ($timer($+($1,.,$2))) { return }
    Wiki.API.Debug Wiki.API.Timer On - $+($1,.,$2) => $3-
    [ $Wiki.API.Offline ] [ $+(.timer,$1,.,$2) ] 1 $Wiki.API.Timeout $3-
  }
  else {
    if (!$timer($+($1,.,$2))) { return }
    Wiki.API.Debug Wiki.API.Timer Off - $+($1,.,$2)
    [ $Wiki.API.Offline ] [ $+(.timer,$1,.,$2) ] off
  }
  return $true
}
; -------- Common Functions --------------------------------------
alias -l HTMLEntities { return $replace($1-,&amp;,&,&quot;,",&lt;,<,&gt;,>,&#039;,') }
alias -l NoHTML { return $regsubex($1,/<[^>]+(?:>|$)|^[^<>]+>/g,) }
alias -l UrlEncode { ; Modification of ZigWap
  if ($prop == Deencode) { return $regsubex($replace($$1,+,$chr(32)),/%([A-F\d]{2})/gi,$chr($base(\1,16,10))) }
  else { return $regsubex($$1,/([\W\s])/Sg,$+(%,$base($asc(\t),10,16,2))) }
}

