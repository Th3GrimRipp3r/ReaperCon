#!/usr/bin/perl

######## Peer Kin Perl - HexChat - Mass Mode ########
######## 2013-03-02 irc.GeekShed.net #ReaperCon ########

## Useage:
###   From the active channel:
###     /mass <+/-> <mode letter>
###   Examples:
###     /mass +v
###     /mass -h

use strict;
use warnings;

my $version = "1.0";

# 2013-03-02 v1.0 Mass Mode

Xchat::register("pkPerl Mass Mode", $version, "pkPerl Mass Mode Script v$version", "");

foreach ("mass", "massmode") { Xchat::hook_command($_, \&massmode); }  # Hook both /mass and /massmode

sub massmode {
	my $context = Xchat::get_context();	# Save the context of our active tab
	my $contextinfo = Xchat::context_info($context);	# Grab the hash of our active tab
	
	my $chantype = $contextinfo->{'type'};	# Check type to see if it is a: 1 => server tab, 2 => channel tab, 3 => dialog tab
	if ($chantype != 2) {	# This is not a channel tab
		Xchat::print("The /mass command can only be used in a channel tab.");
		return Xchat::EAT_XCHAT;
	}
	
	my $me = Xchat::get_info('nick');	# Current nickname
	my $userinfo = Xchat::user_info($me);	# Get our user info on this channel
	my $meprefix = $userinfo->{'prefix'};	# Grab our user prefix on this channel, to check if we are an op here
	if ($meprefix !~ m/^[%@&~!*]/) {	# Are we not an op?
		Xchat::print("The /mass command can only be used by channel operators.");
		return Xchat::EAT_XCHAT;
	}
	
	if ($_[0][1] !~ m/^\s*([+-])\s*([vhoaIeb])/) {	# Parse command parameters
		Xchat::print("The /mass command parameters are in the wrong format.  Examples:  /mass +v  |  /mass -o ");
		return Xchat::EAT_XCHAT;
	}
	
	my $direction = $1;	# Grab the backreference to the + or - of the previous successful match
	my $mode = $2;	# Grab the backreference to the mode letter of the previous successful match
	
	if (($mode =~ m/^[vhoaq]$/) && (index($contextinfo->{'nickmodes'}, $mode) < 0)) {	# Check if this network/channel supports the requested mode
		Xchat::print("This network/channel does not support mode $mode for nicknames.");
		return Xchat::EAT_XCHAT;
	}
	
	my $maxmodes = $contextinfo->{'maxmodes'};	# Find the maximum number of modes per line on this network/channel
	if (!defined($maxmodes)) {
		$maxmodes = 6;	# Set a default of 6 modes if the network does not specify
	}
	
	my $chan = Xchat::get_info('channel');	# Current channel name
	my @Users = Xchat::get_list('users');	# Get an array of all users on the channel in the current context
	
	my $cnt = 0;
	my $line = '';
	my $linecnt = 0;
	foreach my $user (@Users) {	# Go through the list of users on this channel
		my $nickname = $user->{nick};	# Get this user's nickname
		
		if ($nickname eq $me) {	# Skip ourselves
			next;
		}
		
		$cnt++;	# Count one more total nick
		$line .= $nickname . ' ';	# Add this user to the end of the mode line
		$linecnt++;	# Count one more nick on the line
		if ($linecnt == $maxmodes) {	# Ready to send a mode line
			my $moderepeated = $mode x $linecnt;
			Xchat::command("mode $chan $direction" . $moderepeated . " $line");
			
			$line = '';	# Reset line to nothing
			$linecnt = 0;	# Reseting line count to zero
		}
	}
	if ($linecnt > 0) {	# Finished looping through nicknames.  Do we have leftovers to send a mode line?
		my $moderepeated = $mode x $linecnt;
		Xchat::command("mode $chan $direction" . $moderepeated . " $line");
	}
	Xchat::print("Executed mass mode $direction" . "$mode on $cnt nicknames in $chan");
	
	return Xchat::EAT_ALL;	# Tell XChat we handled the command fully
}

Xchat::print("pkPerl Mass Mode v$version loaded.");
