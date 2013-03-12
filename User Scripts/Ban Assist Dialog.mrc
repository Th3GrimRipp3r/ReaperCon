menu channel,menubar,nicklist {
  Ban Assist:dialog $iif($dialog(ban_assist),-v,-m ban_assist) ban_assist
}
dialog ban_assist {
  title "Ban Assist Dialog by Danneh"
  size -1 -1 203 130
  option dbu
  box "Nicknames:", 1, 3 3 66 108
  list 4, 6 10 59 97, size
  box "Options:", 5, 73 3 127 108
  combo 6, 101 14 95 50, size drop
  text "Ban Type:", 7, 76 15 25 8
  text "Example:", 8, 76 43 25 8
  text "", 9, 76 50 120 8
  text "Custom Kick message:", 10, 76 73 53 8, hide
  edit "", 11, 76 79 120 10, hide autohs
  button "Kick", 12, 77 94 37 12
  button "Kick/Ban", 13, 118 94 37 12
  button "Ok", 14, 50 115 37 12, ok
  button "Cancel", 15, 109 115 37 12, cancel
  text "Kick Message:", 16, 76 61 34 8
  combo 17, 110 60 86 50, size drop
  button "Ban Only", 18, 159 94 37 12
  combo 19, 110 29 86 50, size drop
  text "Ext Ban Type:", 20, 76 30 34 8
  menu "File", 2
  item "Close", 3, 2
}
on *:DIALOG:ban_assist:init:*: {
  if (!$ini(ircd.ini,$network,version)) { .version }
  if ($readini(ircd.ini,$network,version) == UnrealIRCd) { didtok $dname 19 124 Normal|~q:|~n:|~q: and ~n: }
  if ($readini(ircd.ini,$network,version) == InspIRCd) { didtok $dname 19 124 Normal|m:|n:|O:|m: and n: }
  if ($readini(ircd.ini,$network,version) == Unknown) { did -a $dname 19 Normal }
  didtok $dname 6 124 1|2|3|4|5
  didtok $dname 17 124 Spamming|Abusive Language|Caps|No PM Permission|Personal Attacks|Bad Attitude|Custom
  var %a = 1
  while (%a <= $nick($active,0)) {
    did -a $dname 4 $nick($active,%a)
    inc %a
  }
}
on *:DIALOG:ban_assist:menu:3: { dialog -x ban_assist }
on *:DIALOG:ban_assist:sclick:4,6,12,13,17-19: {
  if (($did == 4) && ($did(6).sel)) { did -ra $dname 9 $address($did(ban_assist,4).seltext,$did(6).sel) }
  if ($did == 6) { did -ra $dname 9 $address($did(ban_assist,4).seltext,$did(6).sel) }
  if ($did == 12) {
    if ($did(17) != Custom) {
      did -h $dname 10,11
      if ($did(ban_assist,4).seltext == $null) { noop $input(Please select a nick to kick.,o) }
      else {
        if ($did(17) == Spamming) { kick $active $did(ban_assist,4).seltext Spamming is not tolerated here. }
        elseif ($did(17) == Abusive Language) { kick $active $did(ban_assist,4).seltext Please watch your language. We want everyone to feel welcome here. }
        elseif ($did(17) == Caps) { kick $active $did(ban_assist,4).seltext Talking in caps is considered yelling, annoying, and rude. Please turn them off. Thanks. }
        elseif ($did(17) == No PM Permission) { kick $active $did(ban_assist,4).seltext You may not PM/DCC/Notice/Query/CTCP users without their expressed permission. }
        elseif ($did(17) == Personal Attacks) { kick $active $did(ban_assist,4).seltext Personal attacks are not tolerated here. }
        elseif ($did(17) == Bad Attitude) { kick $active $did(ban_assist,4).seltext Your attitude is not conducive to the desired environment. }
      }
    }
    if ($did(17) == Custom) { 
      did -v $dname 10,11
      if ($did(11) == $null) { noop $input(Please enter a Custom Kick Message.,o) }
      else { kick $active $did(ban_assist,4).seltext $did(11) }
    }
  }
  if ($did == 13) {
    if ($did(17) != Custom) {
      did -h $dname 10,11
      if ($did(ban_assist,4).seltext == $null) { noop $input(Please select a nick to kick.,o) }
      else {
        if ($did(ban_assist,19).seltext == Normal) { 
          if ($did(17) == Spamming) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext Spamming is not tolerated here. }
          elseif ($did(17) == Abusive Language) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext Please watch your language. We want everyone to feel welcome here. }
          elseif ($did(17) == Caps) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext Talking in caps is considered yelling, annoying, and rude. Please turn them off. Thanks. }
          elseif ($did(17) == No PM Permission) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext You may not PM/DCC/Notice/Query/CTCP users without their expressed permission. }
          elseif ($did(17) == Personal Attacks) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext Personal attacks are not tolerated here. }
          elseif ($did(17) == Bad Attitude) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext Your attitude is not conducive to the desired environment. }
        }
        else {
          if ($did(19).seltext == ~q:) { var %a = mode $active +b ~q: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == ~n:) { var %a = mode $active +b ~n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == ~q: and ~n:) { var %a = mode $active +bb ~q: $+ $address($did(ban_assist,4).seltext, $did(6)) ~n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == m:) { var %a = mode $active +b m: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == n:) { var %a = mode $active +b n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == O:) { var %a = mode $active +b O: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == m: and n:) { var %a = mode $active +b m: $+ $address($did(ban_assist,4).seltext, $did(6)) n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(19).seltext == Normal) { var %a = mode $active +b $address($did(ban_assist,4).seltext, $did(6)) }
          elseif ($did(17) == Spamming) { var %b = kick $active $did(ban_assist,4).seltext Spamming is not tolerated here. }
          elseif ($did(17) == Abusive Language) { var %b = kick $active $did(ban_assist,4).seltext Please watch your language. We want everyone to feel welcome here. }
          elseif ($did(17) == Caps) { var %b = kick $active $did(ban_assist,4).seltext Talking in caps is considered yelling, annoying, and rude. Please turn them off. Thanks. }
          elseif ($did(17) == No PM Permission) { var %b = kick $active $did(ban_assist,4).seltext You may not PM/DCC/Notice/Query/CTCP users without their expressed permission. }
          elseif ($did(17) == Personal Attacks) { var %b = kick $active $did(ban_assist,4).seltext Personal attacks are not tolerated here. }
          elseif ($did(17) == Bad Attitude) { var %b = kick $active $did(ban_assist,4).seltext Your attitude is not conducive to the desired environment. }
          %a | %b
        }
      }
    }
    if ($did(17) == Custom) { 
      did -v $dname 10,11
      if ($did(11) == $null) { noop $input(Please enter a Custom Kick Message.,o) }
      else { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) | kick $active $did(ban_assist,4).seltext $did(11) }
    }
  }
  if ($did == 17) { 
    if ($did(17) != Custom) { did -h $dname 10,11 }
    elseif ($did(17) == Custom) { did -v $dname 10,11 }
  }
  if ($did == 18) {
    if ($did(ban_assist,4).seltext == $null) { noop $input(Please select a nick to Ban.,o) }
    elseif ($did(19).seltext != Normal) {
      if ($did(19).seltext == ~q:) { mode $active +b ~q: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == ~n:) { mode $active +b ~n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == ~q: and ~n:) { mode $active +bb ~q: $+ $address($did(ban_assist,4).seltext, $did(6)) ~n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == m:) { mode $active +b m: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == n:) { mode $active +b n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == O:) { mode $active +b O: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == m: and n:) { mode $active +b m: $+ $address($did(ban_assist,4).seltext, $did(6)) n: $+ $address($did(ban_assist,4).seltext, $did(6)) }
      elseif ($did(19).seltext == Normal) { mode $active +b $address($did(ban_assist,4).seltext, $did(6)) }
    }
  }
}
RAW 002:*:{ 
  if (!$ini(ircd.ini,$network,version)) {
    if (Unreal isin $2-) { writeini ircd.ini $network version UnrealIRCd }
    if (InspIRCd isin $2-) { writeini ircd.ini $network version InspIRCd }
    elseif (!$istok(Unreal|InspIRCd,$2-,124)) { writeini ircd.ini $network version Unknown }
  }
}
RAW 351:*:{
  if (!$ini(ircd.ini,$network,version)) {
    if (Unreal isin $2-) { writeini ircd.ini $network version UnrealIRCd }
    elseif (InspIRCd isin $2-) { writeini ircd.ini $network version InspIRCd }
    elseif (!$istok(Unreal|InspIRCd,$2-,124)) { writeini ircd.ini $network version Unknown }
  }
}
