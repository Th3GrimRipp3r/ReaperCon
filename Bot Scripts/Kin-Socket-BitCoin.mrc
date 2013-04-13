; ----------------------------------------------------------------
; Kin's Current BitCoin Price Info Script - mSL for mIRC
; ----------------------------------------------------------------
; KinKinnyKith - Kin "Kinny" Kith
; #ReaperCon #mIRC #Script-Help #Bots #RegEx - IRC.GeekShed.Net
; ----------------------------------------------------------------
; For #SubWolf irc.GeekShed.Net
; Hosted at https://github.com/Th3GrimRipp3r/ReaperCon
; 2013-04-12
; ----------------------------------------------------------------
; Simple socket script to look up BitCoin prices from APIs:
; http://blockchain.info/api/exchange_rates_api
;   http://blockchain.info/ticker
; Possible alternate APIs:
; http://blockchain.info/api/charts_api
;   http://blockchain.info/stats?format=json
; https://en.bitcoin.it/wiki/MtGox/API/HTTP/v1
;   http://data.mtgox.com/api/1/BTCUSD/ticker
; ----------------------------------------------------------------
; 2013-04-13 v1.2 Minor fixes
; 2013-04-13 v1.1 Output formatting
; 2013-04-12 v1.0 Start
; ----------------------------------------------------------------

; --------- Config

alias -l Kin.BitCoin.Config.Networks { return GeekShed }
alias -l Kin.BitCoin.Config.Channels { return #SubWolf #ReaperCon }
alias -l Kin.BitCoin.Config.SocketTimeout { return 12 }
alias -l Kin.BitCoin.Config.SecondsBetweenUpdates { return 60 }

; --------- Events

on *:UNLOAD: {
  unset %Kin.BitCoin.*
  hfree Kin.BitCoin.*
}

on *:INPUT:#: {
  if ($ctrlenter) { return }
  if ($Kin.BitCoin.ValidCommand($1-) == $true) {
    msg $chan $1-
    noop $Kin.BitCoin.Command($iif($2,$v1,Ticker),!msg $chan)
    HALT
  }
}

on *:TEXT:*:#: {
  if ($Kin.BitCoin.ValidCommand($1-) == $true) {
    if ($nick !isop $chan) && ($nick !ishop $chan) && ($nick !isvoice $chan) { return }
    noop $Kin.BitCoin.Command($iif($2,$v1,Ticker),!msg $chan)
  }
}

; -------- Command Aliase

alias Kin.BitCoin.Command {
  var %cmd $1
  var %callback $ValidCallback($2)

  var %currencyoptions $Kin.BitCoin.CurrencyOptions

  var %help !bitcoin to see the 15 minute delayed BitCoin values in USD and GBP, or use !bitcoin USD and select from these currency options: %currencyoptions

  if (%cmd == help) {
    %callback %help
  }
  elseif (%cmd == $null) || (%cmd == Ticker) || (%cmd == check) || (%cmd == long) || ($istok(%currencyoptions,$upper(%cmd),32)) {
    var %lastcheck $calc($ctime - $hget(Kin.BitCoin.TickerData,LastCheck))
    if (!$hget(Kin.BitCoin.TickerData)) || (%lastcheck > $Kin.BitCoin.Config.SecondsBetweenUpdates) { 
      .hadd -m Kin.BitCoin Command %cmd
      .hadd -m Kin.BitCoin Callback %callback
      Kin.BitCoin.Get.Ticker
    }
    else {
      noop $Kin.BitCoin.Report(%cmd,%callback)
    }
  }
  elseif (%cmd == last) {
    noop $Kin.BitCoin.Report(%cmd,%callback)
  }
  else {
    %callback %help
  }
}

alias -l Kin.BitCoin.Next {
  var %hash Kin.BitCoin
  var %cmd $hget(%hash,Command), %callback $hget(%hash,Callback)
  if (%cmd) && (%callback) {
    noop $Kin.BitCoin.Command(%cmd,%callback)
  }
}

alias -l Kin.BitCoin.Report {
  var %cmd $1
  var %callback $ValidCallback($2)
  var %out (BitCoin)

  var %currencyoptions $Kin.BitCoin.CurrencyOptions

  if ($istok(%currencyoptions,$upper(%cmd),32)) {
    %out = %out $Kin.BitCoin.Format($upper(%cmd),$true)
  }
  else {
    %out = %out $Kin.BitCoin.Format(USD) -- $Kin.BitCoin.Format(GBP)
  }

  if ($len(%out) > 20) {
    %callback %out
  }
}

; -------- Assist Aliases

alias -l Kin.BitCoin.ValidCommand {
  if (!$istok($Kin.BitCoin.Config.Networks,$network,32)) { return $false }
  if (!$istok($Kin.BitCoin.Config.Channels,$chan,32)) { return $false }
  if (!$regex($1-,/^[!@`]bit\s*coin/Si)) { return $false }
  return $true
}

alias ValidCallback {
  if (!$1) && (!$istok(say msg echo notice describe,$replace($1,!,),32)) { return !echo -ta }
  else { return $1- }
}

alias -l Kin.BitCoin.CurrencyOptions {
  var %currencyoptions $sorttok($hget(Kin.BitCoin.TickerData,Currencies),32)
  if (!%currencyoptions) { %currencyoptions = USD CNY JPY SGD HKD CAD AUD NZD GBP DKK SEK BRL CHF EUR RUB SLL PLN THB }
  return %currencyoptions
}

alias -l CurrencyHashName { return $+($1,.,$2) }

alias -l Kin.BitCoin.Free.Ticker {
  if $hget(Kin.BitCoin.TickerData) { hfree -w Kin.BitCoin.TickerData* }
}

alias -l Kin.BitCoin.Format {
  var %currencyhashname $CurrencyHashName(Kin.BitCoin.TickerData,$1)
  if (!%currencyhashname) { return $null }

  var %long $false
  if ($2 == $true) { %long = $true }

  var %first $true
  if ($3 == $false) || ($1 != USD) { %first = $false }

  var %type 1
  if (%type == 1) {
    var %frmt 

    if (%first == $true) { %frmt = %frmt symbol15m (Current Price $1 $+ ) symbol24h (24-Hour Average) }
    else { %frmt = %frmt 15m symbol (Current Price $1 $+ ) 24h symbol (24-Hour Average) }

    if (%long == $true) {
      if (%first == $true) { %frmt = %frmt symbollast (Last) symbolbuy (Buy) symbolsell (Sell) }
      else { %frmt = %frmt last symbol (Last) buy symbol (Buy) sell symbol (Sell) }
    }
  }
  elseif (%type == 2) {
    var %frmt $+($chr(91),$1,$chr(93))

    if (%first == $true) { %frmt = %frmt (Current Price) symbol15m (24-Hour Average) symbol24h }
    else { %frmt = %frmt (Current Price) 15m symbol (24-Hour Average) 24h symbol }

    if (%long == $true) {
      if (%first == $true) { %frmt = %frmt (Last) symbollast (Buy) symbolbuy (Sell) symbolsell }
      else { %frmt = %frmt (Last) last symbol (Buy) buy symbol (Sell) sell symbol }
    }
  }

  var %keys 15m|last|buy|sell|24h|symbol
  var %out $Kin.HashKeyMapFormat(%currencyhashname,%keys,%frmt)

  if (!%out) { return $null }
  return %out
}

alias -l Kin.HashKeyMapFormat {
  var %hash $1
  var %alternations $2
  var %formatstring $3
  return $regsubex(keymap,%formatstring,/( $+ %alternations $+ )/g,$iif($hget(%hash,\1),$v1,unknown))
}

; -------- Socket Aliases

alias -l Kin.BitCoin.Get.Ticker {
  var %sock Kin.BitCoin.TickerData

  if ($timer(Kin.BitCoin.Timeout)) { return }

  Kin.BitCoin.Free.Ticker
  Kin.BitCoin.Timeout %sock

  .hadd -m %sock Host blockchain.info
  .hadd %sock Path /ticker
  .timerKin.BitCoin.Timeout 1 $Kin.BitCoin.Config.SocketTimeout Kin.BitCoin.Timeout
  sockopen %sock $hget(%sock,Host) 80
}

alias -l Kin.BitCoin.Timeout {
  sockclose $1
  .timerKin.BitCoin.Timeout off
}

alias -l Kin.BitCoin.Close {
  Kin.BitCoin.Timeout $1

  Kin.BitCoin.Next
}

; -------- Socket Events

on *:SOCKOPEN:Kin.BitCoin.*: {
  var %host $hget($sockname,Host), %path $hget($sockname,Path)
  if (!%host) && (!%path) { return }

  sockwrite -nt $sockname GET %path HTTP/1.0
  sockwrite -nt $sockname HOST: %host
  sockwrite -nt $sockname Accept-Encoding: 
  sockwrite -nt $sockname Connection: close
  sockwrite -nt $sockname $crlf
}

on *:SOCKREAD:Kin.BitCoin.TickerData: {
  if ($sockerr) { !echo -ts 04Socket Error in SOCKREAD - $sock($sockname).wserr -  $sock($sockname).wsmsg | .sockclose $sockname | halt }

  var %SR
  while ($sock($sockname).rq) {
    sockread -f %SR
    if ("15m" isin %SR) { Kin.BitCoin.Add.Currency $sockname %SR }
  }
}

on *:SOCKCLOSE:Kin.BitCoin.*: { Kin.BitCoin.Close $sockname }

; -------- API Aliases

alias -l Kin.BitCoin.Add.Currency {
  var %hashname $1
  var %jsonline $2-
  var %newcurrency $Kin.BitCoin.Ticker.Parse(%hashname,%jsonline)
  if (%newcurrency) {
    var %knowncurrencies $hget(%hashname,Currencies)
    var %nowcurrencies $addtok(%knowncurrencies,%newcurrency,32)
    .hadd %hashname Currencies %nowcurrencies 
    .hadd %hashname LastCheck $ctime
  }
}

alias -l Kin.BitCoin.Ticker.Parse {
  var %hashnamebase $1
  var %jsonline $2-
  if ($regex(%hashnamebase,%jsonline,/"([A-Z]{3})"\s*:\s*\{/)) {
    var %currency $regml(%hashnamebase,1)
    var %currencyhash $jsonparse($CurrencyHashName(%hashnamebase,%currency),%jsonline)
    if (%currencyhash) {
      .hadd %currencyhash Currency %currency
      return %currency
    }
  }
  return $null
}

; -------- JSON to Hash Parser

; Kin irc.GeekShed.net #Script-Help

; Usage: $jsonparse(UniqueHashTableNameToFillWithData,%StringofJSON)
; Returns: Hash table name if found at least one json item:data pair, or $null

; Example:
alias -l jsonparserexample {
  var %json {"status":200,"msg":"OK"}
  var %uniquehashname MyHashName $+ $ticks
  var %returnhash $jsonparse(%uniquehashname,%json)

  if (!%returnhash) { echo -tag The JSON could not be parsed }
  elseif ($hget(%returnhash,status)) { echo -tag The status is $v1 }
  elseif ($hget(%returnhash,status).item) { echo -tag The status is not set to anything }
  else { echo -tag There is no status item in the json }

  ; Remember to free up your memory after you are done with the hash
  hfree %returnhash
}

; Identifier:
alias -l jsonparse {
  var %h $1
  var %json $2-
  var %jsonpattern /"([^"]+)"\s*:\s*("[^"]*"|[^"}{][^,}{]+)/g
  var %matches $regex(jsonparse,%json,%jsonpattern)

  ; load up a hash table with our item:data pairs
  while (%matches > 0) {
    var %item $regml(jsonparse,$calc((%matches * 2) - 1))
    var %data $regml(jsonparse,$calc(%matches * 2))
    if ("*" iswm %data) { %data = $mid(%data,2,$calc($len(%data) - 2)) }
    hadd -m %h %item %data
    dec %matches
  }

  if ($hget(%h,0).item > 0) { return %h }
  else { return $null }
}
