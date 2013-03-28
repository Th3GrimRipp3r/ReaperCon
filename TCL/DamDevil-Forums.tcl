##########################################
####  DamDevil Forum Script by Danneh ####
##########################################
####          Begin Setup             ####
##########################################

set DDFTrig "!"

##########################################
####             End Setup            ####
##########################################

bind pub - ${DDFTrig}Forums DD:Forums

proc DD:Forums {nick host hand chan argv} {
  if {[lsearch -exact [channel info $chan] +DDForumz] != +1} {
    set DDLogo "\0034D\003am\0034D\003evil"
	set DDURL "forums.damdevil.org"
	if {[catch {set DDSock [socket -async $DDURL 80]} sockerr]} {
	  return 0
	} else {
	  puts $DDSock "GET / HTTP/1.0"
	  puts $DDSock "Host: $DDURL"
	  puts $DDSock "User-Agent: Opera 9.6"
	  puts $DDSock ""
	  flush $DDSock
	  while {![eof $DDSock]} {
	    set DDStatus "[gets $DDSock]"
		if {[regexp -all {<p>Total posts <strong>(.*?)</strong> &bull; Total topics <strong>(.*?)</strong> &bull; Total members <strong>(.*?)</strong> &bull; Our newest member <strong><a href="./memberlist.php?mode=viewprofile.*?">(.*?)</a></strong></p>} $DDStatus match DDPosts DDTopics DDMembers DDNewest]} {
		  putserv "PRIVMSG $chan :$DDLogo Forums\:"
		  putserv "PRIVMSG $chan :Total Posts: $DDPosts"
		  putserv "PRIVMSG $chan :Total Topics: $DDTopics"
		  putserv "PRIVMSG $chan :Total Members: $DDMembers"
		  putserv "PRIVMSG $chan :Newest Member: $DDNewest"
		  close $DDSock
		  return 0
		}
      }
	}
  }
}
	
setudef flag DDForumz
putlog "DamDevil Forum Stats Loaded.."
