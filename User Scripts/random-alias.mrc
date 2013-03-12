;;;;; Some useful Aliases 
/ban /ban -k $active $$1
/op /mode $active +ooooo $$1 $2 $3 $4 $5
/deop /mode $active -ooooo $$1 $2 $3 $4 $5
/v /mode $active +vvvvv $$1 $2 $3 $4 $5
/dv /mode  $active -vvvvv $$1 $2 $3 $4 $5
/h /mode $active +hhhhh $$1 $2 $3 $4 $5
/dh /mode $active -hhhhh $$1 $2 $3 $4 $5
/whois /whois $$1 $$1
/invite /invite $$1 $chan
/j /join $$1 $2
/p /part #
/w /whois $$1 $$1-
/b /ban $active $$1
/k /kick $chan $$1 
/q /query $$1
/s /server $$1-
/nocolor { /ignore -k $$1 }
mm { scid -a nick $1 }
irc { msg # i am using mIRC $version $+ . }
is { msg # i am connected to $server }

;;;;; Oper Aliases ;;;;;;;;;
/fhop /sapart $$1 # | /sajoin $$1 #
/cop /chatops $$1
/nop /nachat $$1
/gop /globops $$1

