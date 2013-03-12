#!/usr/bin/perl

# 2013-01-24 v1.1 Minor Tweaks
# 2013-01-24 v1.0 Request by Wisal #Script-Help irc.geekshed.net

use strict;
use warnings;

Xchat::register("Kin's Dumbfire AutoGhost AutoID", '1.1', 'Automatically Ghost, Nick and Identify on Connection');

# Improved method - Uses nick and nickserv password as configured in Xchat's Network List
Xchat::hook_print('Connected', \&ImprovedAutoGhostID);
# Simple method - Change network, nickname, and password in sub
# Xchat::hook_print('Connected', \&AutoGhostID);

sub AutoGhostID {
  ##### Update this with your network name, preferred nick, and nickserv password
	my $ValidNetwork = 'MyFavNet';
	my $MainNick = 'AutoIDbyKin';
	my $NickPass = 'Pass4AutoIDbyKin';
	#####
	if ((Xchat::get_info('network') eq $ValidNetwork) || (Xchat::get_info('server') =~ m/(($ValidNetwork))/i)) {
		Xchat::print("\nAuto-ghosting and auto-identifying...\n\n");
		if (Xchat::get_info('nick') ne $MainNick) {
			Xchat::command("timer -refnum 3 -repeat 1 8 ns ghost $MainNick $NickPass");
			Xchat::command("timer -refnum 4 -repeat 1 10 ns release $MainNick $NickPass");
		}
		Xchat::command("timer -refnum 5 -repeat 1 16 nick $MainNick");
		Xchat::command("timer -refnum 6 -repeat 1 20 ns identify $MainNick");
	}
	return Xchat::EAT_NONE;
}

sub ImprovedAutoGhostID {
	# Grab info about this connection and network preferences
	my $NetName = Xchat::get_info('network');
	my $Me = Xchat::get_info('nick');
	my $MainNick = Xchat::get_prefs('irc_nick1');
	my $NickPass = Xchat::get_info('nickserv');

	# Show some info on connection
	Xchat::print("\nConnected to $NetName as $Me \n\n");

	# Check if a nick and password are defined in XChat's network list
	if (defined($MainNick) && defined($NickPass)) {
		Xchat::print("\nAuto-ghosting and auto-identifying...\n\n");
		if (Xchat::get_info('nick') ne $MainNick) {
			Xchat::command("timer -refnum 3 -repeat 1 8 ns ghost $MainNick $NickPass");
			Xchat::command("timer -refnum 4 -repeat 1 10 ns release $MainNick $NickPass");
		}
		Xchat::command("timer -refnum 5 -repeat 1 16 nick $MainNick");
		Xchat::command("timer -refnum 6 -repeat 1 20 ns identify $MainNick");
	}
	return Xchat::EAT_NONE;
}

Xchat::print("\nKin's Dumbfire AutoGhost AutoID Script v1.1 Loaded\n\n");
