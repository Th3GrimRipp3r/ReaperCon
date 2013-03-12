menu channel,status {
  Channel Modes by Danneh:$iif($active == Status Window,noop $input(Please select an active channel.,o),dialog $iif($dialog(chan_modes),-v,-m chan_modes) chan_modes)
}
dialog chan_modes {
  title "Channel Modes"
  size -1 -1 190 249
  option dbu
  text "c = Block messages containing mIRC color codes [o]", 3, 3 3 124 8, hide
  text "i = A user must be invited to join the channel [h]", 4, 3 13 116 8, hide
  text "m = Moderated channel (only +vhoaq users may speak) [h]", 5, 3 23 143 8, hide
  text "n = Users outside the channel can not send PRIVMSGs to the channel [h]", 6, 3 33 175 8, hide
  text "p = Private channel [o]", 7, 3 43 56 8, hide
  text "r = The channel is registered (settable by services only)", 8, 3 53 134 8, hide
  text "s = Secret channel [o]", 9, 3 63 54 8, hide
  text "t = Only +hoaq may change the topic [h]", 10, 3 73 99 8, hide
  text "z = Only Clients on a Secure Connection (SSL) can join [o]", 11, 3 83 139 8, hide
  text "A = Server/Net Admin only channel (settable by Admins)", 12, 3 93 136 8, hide
  text "C = No CTCPs allowed in the channel [o]", 13, 3 103 97 8, hide
  text "G = Filters out all Bad words in messages with <censored> [o]", 14, 3 113 150 8, hide
  text "M = Must be using a registered nick (+r), or have voice access to talk [o]", 15, 3 123 175 8, hide
  text "K = /KNOCK is not allowed [o]", 16, 3 133 72 8, hide
  text "N = No Nickname changes are permitted in the channel [o]", 17, 3 143 140 8, hide
  text "O = IRC Operator only channel (settable by IRCops)", 18, 3 153 127 8, hide
  text "Q = No kicks allowed [o]", 19, 3 163 58 8, hide
  text "R = Only registered (+r) users may join the channel [o]", 20, 3 173 133 8, hide
  text "S = Strips mIRC color codes [o]", 21, 3 183 75 8, hide
  text "T = No NOTICEs allowed in the channel [o]", 22, 3 193 103 8, hide
  text "V = /INVITE is not allowed [o]", 23, 3 203 71 8, hide
  text "u = Auditorium mode (/names and /who #channel only show channel ops) [q]", 24, 3 213 185 8, hide
  text "[h] requires at least halfop, [o] requires at least chanop, [q] requires owner", 25, 30 227 119 15
  menu "File", 1
  item "Close", 2, 1, ok
}
on *:DIALOG:chan_modes:init:*: {
  set %chanmodes $remove($chan($active).mode,$chr(43))
  .timerchanmode 1 1 chanmodecheck
}
alias -l chanmodecheck {
  if (c isincs %chanmodes) { did -v chan_modes 3 }
  if (i isincs %chanmodes) { did -v chan_modes 4 }
  if (m isincs %chanmodes) { did -v chan_modes 5 }
  if (n isincs %chanmodes) { did -v chan_modes 6 }
  if (p isincs %chanmodes) { did -v chan_modes 7 }
  if (r isincs %chanmodes) { did -v chan_modes 8 }
  if (s isincs %chanmodes) { did -v chan_modes 9 }
  if (t isincs %chanmodes) { did -v chan_modes 10 }
  if (z isincs %chanmodes) { did -v chan_modes 11 }
  if (A isincs %chanmodes) { did -v chan_modes 12 }
  if (C isincs %chanmodes) { did -v chan_modes 13 }
  if (G isincs %chanmodes) { did -v chan_modes 14 }
  if (M isincs %chanmodes) { did -v chan_modes 15 }
  if (K isincs %chanmodes) { did -v chan_modes 16 }
  if (N isincs %chanmodes) { did -v chan_modes 17 }
  if (O isincs %chanmodes) { did -v chan_modes 18 }
  if (Q isincs %chanmodes) { did -v chan_modes 19 }
  if (R isincs %chanmodes) { did -v chan_modes 20 }
  if (S isincs %chanmodes) { did -v chan_modes 21 }
  if (T isincs %chanmodes) { did -v chan_modes 22 }
  if (V isincs %chanmodes) { did -v chan_modes 23 }
  if (u isincs %chanmodes) { did -v chan_modes 24 }
  if (%chanmodes == $null) { noop $input(There are no channel modes on $active $+ .,o) | dialog -x chan_modes }
}
on *:DIALOG:chan_modes:close:*: {
  unset %chanmodes
}
