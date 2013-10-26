# Kin's Voice Nickname That Messages A Keyword
# 2013-10-26
# v1.5

# namespace eval kin_voice_on_keyword {
	set kin_version "Kin's Voice Nickname That Messages A Keyword v1.5 2013-10-26"
	
	## Version History
	## 2013-10-26 - v1.5 - Debug timer matching
	## 2013-10-25 - v1.4 - Use event driven century time difference, insead of countdown timer
	## 2013-10-25 - v1.3 - Array of nicks to voice on join
	## 2013-10-25 - v1.2 - Timers
	## 2013-10-25 - v1.1 - Binds and puts
	## 2013-10-25 - v1.0 - Start request

	####### Configuration #######
	
	set listen_channel "#Listen"
	set keyword "voicemeplease"

	set voice_channel "#Voice"
	set max_wait_for_join 12
	
	set primary_bot_nick "Kin"
	set botserv_nick "GLaDOS"
	
	####### Procedures #######
	
	array set voice_nicks {}
	
	proc keyword_from_nick {nick userhost handle channel text} {
		global primary_bot_nick listen_channel voice_channel
		# Is the primary bot alreadly doing the voicing? (we are the backup)
		if {[onchan $primary_bot_nick $listen_channel]} { return 0 }
		# Was the keyword sent to the correct listening channel?
		if {![string equal -nocase $channel $listen_channel]} { return 0 }
		# Are they banned/muted on the main channel?
		if {[is_nick_muted $nick $userhost $voice_channel] == 1} { return 0 }
		# Try to voice the nick immediately
		if {[voice_nick $nick] == 1} {
			# Schedule a voicing when the do finally join the channel
			schedule_voicing $nick
		}
		return 0
	}
	
	proc is_nick_muted {nick userhost channel} {
		# TO DO ##########
		# if {[ischanban <ban> $channel] == 1} { return 1 }
		return 0
	}
	
	proc voice_nick {nick} {
		global voice_channel botserv_nick
		# Am I on the voicing channel to be aware of what's going on?
		if {![validchan $voice_channel]} { return 0 }
		if {![botonchan $voice_channel]} { return 0 }
		# Is the nick to be voiced even joined to the channel? (yet?)
		if {![onchan $nick $voice_channel]} {
			# Schedule a future voicing
			return 1
		}
		# Is nick is already voiced?
		if {[isvoice $nick $voice_channel]} { return 0 }
		# Use botserv to voice if it is on the channel (services are up)
		if {[onchan $botserv_nick $voice_channel]} {
			putquick "CS VOICE $voice_channel $nick"
			return 0
		}
		# Voice the nick ourselves if we are op
		if {[botisop $voice_channel]} {
			pushmode $voice_channel +v $nick
			# putquick "MODE voice_channel +v $nick"
			return 0
		}
		# Cannot voice any users, no need to schedule future voicing for this user
		return 0
	}
	
	proc schedule_voicing {nick} {
		global voice_nicks
		# Add nick to voice flag list/hash
		# ctime
		set voice_nicks($nick) [clock seconds]
		# ticks
		# set voice_nicks($nick) [clock clicks -milliseconds]

		# Start a timer to remove them from the voicing list
		set_timer $nick
	}
	
	proc set_timer {nick} {
		global max_wait_for_join
		kill_timer $nick
		# set thistimer [utimer $max_wait_for_join [list [voice_nick nick]]]
		set utimerid [utimer [expr {$max_wait_for_join + 2}] [list voicing_complete $nick]]
	}
	
	proc kill_timer {nick} {
		# Go through all timers to find an existing timer ID for this nick
		foreach utimer [utimers] {
			set callback [lindex $utimer 1]
			set utimerid [lindex $utimer 2]
			if {
				[lsearch -exact [lindex $callback 0] voicing_complete] == 0 &&
				[lsearch -exact [lindex $callback 1] $nick] == 0
			} then {
				killutimer $utimerid
			}
		}
	}
	
	proc nick_joins_channel {nick userhost handle channel} {
		global voice_nicks voice_channel max_wait_for_join
		# Are they joining the correct channel for voicing?
		if {![string equal -nocase $channel $voice_channel]} { return 0 }
		# Are they on our voicing list?
		if {![info exists voice_nicks($nick)]} { return 0 }
		# Grab the ctime/ticks the keyword was found
		set keywordtime $voice_nicks($nick)
		# Did they join soon enough to get their voice?
		if {[clock seconds] <= [expr {$keywordtime  + $max_wait_for_join}]} {
			voice_nick $nick
		} else {
			# Too slow, they don't get voiced
		}
		# Remove their timer and key in the array
		voicing_complete $nick
	}
	
	proc voicing_complete {nick} {
		global voice_nicks
		# Remove the timer for this nick, if it exists
		kill_timer $nick
		# Remove nick key from voice array
		if {[info exists voice_nicks($nick)]} { 
			unset voice_nicks($nick)
		}
	}
	
	####### Binds #######
	
	bind pub - ${keyword} keyword_from_nick
	bind join - "${voice_channel} *" nick_joins_channel
	
	####### Log Startup #######
	
	putlog $kin_version
# }
