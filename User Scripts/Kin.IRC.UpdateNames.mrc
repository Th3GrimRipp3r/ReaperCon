; 2014-03-11 v1.1 Add configuration options, and general cleanup
; 2014-03-11 v1.0 

; ==== Configuration
alias -l ShowProgressMessages { return $true }              | ; Do you want to echo messages to your status window?
alias -l SecondsToWait.BeforeStarting { return 200 }        | ; Enter the delay of seconds (after the last /join to a channel) before checking if /names is required
alias -l SecondsToWait.BetweenServerRequests { return 12 }  | ; Enter the delay of seconds between /names requests

; ==== Events
on *:JOIN:*: {
  if ($nick != $me) { return }
  var %thistime $iif($SecondsToWait.BeforeStarting isnum 1-86000,$v1,200)                                               | ; Defend against misconfiguration
  if ($ShowProgressMessages) { !echo -tsg (Kin.IRC.UpdateNames) 07Checking Channel Internal Address List > $chan < }  | ; Echo progress
  .timerKin.IRC.UpdateNames.Start 1 %thistime  Kin.IRC.UpdateNames                                                      | ; Reset timer to wait 
}
on *:START: { unset %Kin.IRC.UpdateNames.Last }                                                                         | ; Cleanup set variables if mIRC crashed

; ==== Identifier
; -> $Kin.IRC.IALfalseChans <- Identifier returns a space delimited list of all channels that require a /names update
alias Kin.IRC.IALfalseChans { return $regsubex(Kin.IRC.IALfalseChans,$str(.,$chan(0)),/./g,$iif($chan(\n).ial == $false,$chan(\n) $+ $chr(32))) }

; ==== Alias
; -> /Kin.IRC.UpdateNames <- Command to update the internal address lists for all joined channels 
alias Kin.IRC.UpdateNames {
  var %thischan $gettok($Kin.IRC.IALfalseChans,1,32)                                | ; The name of the next channel that requres an update
  if (!%thischan) {
    if ($ShowProgressMessages) { !echo -tsg (Kin.IRC.UpdateNames) 04Finished! }   | ; Echo progress
    unset %Kin.IRC.UpdateNames.Last | .timerKin.IRC.UpdateNames.Start off | return  | ; No more channels to update
  }
  if (%Kin.IRC.UpdateNames.Last != %thischan) { !names %thischan }                  | ; Update the Internal Address List for this channel
  set -e %Kin.IRC.UpdateNames.Last %thischan                                        | ; Remember our last checked channel, so we don't flood /names to a lagging server
  Kin.IRC.UpdateNames.CheckAgain                                                    | ; Start a delay timer, to check if another channel requires an update
}

; ==== Delay Timer

alias -l Kin.IRC.UpdateNames.CheckAgain {
  var %thistime $iif($SecondsToWait.BetweenServerRequests isnum 1-600,$v1,12)            | ; Defend against misconfiguration
  if ($ShowProgressMessages) { !echo -tsg (Kin.IRC.UpdateNames) 11Checking again... }  | ; Echo progress
  .timerKin.IRC.UpdateNames.CheckAgain 1 %thistime Kin.IRC.UpdateNames                   | ; Our delay timer. Check if another channel requires an update
}
