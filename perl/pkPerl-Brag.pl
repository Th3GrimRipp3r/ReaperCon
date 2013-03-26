#!/usr/bin/perl

######## Peer Kin Perl - HexChat - Power - Brag ########
######## 2013-02-23 irc.GeekShed.net #ReaperCon ########

use strict;
use warnings;
# use Data::Dump qw(dump);

my $version = "1.9";

# 2013-03-25 v1.9 Output formatting with sprintf
# 2013-03-25 v1.8 Substitute server name for undefined network names
# 2013-02-24 v1.7 Count network o-lines
# 2013-02-24 v1.6 Use singluar or plural words properly in the output message
# 2013-02-24 v1.5 Compare channel power with an integer assigned value returned from prefix2value
# 2013-02-24 v1.4 Don't count nicknames multiple times, if they are joined to more than one channel that we share with them
# 2013-02-23 v1.3 Count only nicknames that are equal or lesser in channel power; Don't include nicknames that have a higher prefix, even if we are an op on the channel
# 2013-02-23 v1.2 Add the total number of users in all channels
# 2013-02-23 v1.1 Add * ! ~ prefixes as owners, and & as admin
# 2013-02-23 v1.0 Power Brag

Xchat::register("pkPerl Power Brag", $version, "pkPerl Power Brag Script v$version", "");

foreach ("power", "brag") { Xchat::hook_command($_, \&power); }  # Hook both /power and /brag

sub power {
	my $startcontext = Xchat::get_context();	# Save context for later, so we can send our message to the active network and channel at the end of the script
	my $startchannel = Xchat::get_info('channel');
	
	my @channels = Xchat::get_list('channels');	# Get an array of all channels

	my %powercount = (	network => 0,	# Create a hash to keep our keyval counts
				channel => 0,
				user => 0,
				owner => 0,
				admin => 0,
				op => 0,
				halfop => 0,
				voice => 0,
				regular => 0,
				kickable => 0,
				uniquenicks => 0,
	);

	## Build a hash consisting of each unique nickname on each network. Use this hash to avoid ##    
	## counting the same nickname twice, when counting up the number of people we can kick     ##
	my %NetNickList;

	foreach my $chanitem (@channels){	# Iterate through each channel
		my $chantype = $chanitem->{'type'};	# Check type to see if it is a ( 1 => server window, 2 => channel window, 3 => dialog window )
		if ($chantype == 1) {	# This is a server window, add to network count
			$powercount{'network'}++;
		} elsif ($chantype == 2) {	# This is a channel window
			$powercount{'channel'}++;

			my $chan = $chanitem->{'channel'};	# Get channel name
			Xchat::set_context("$chan");	# Set context for the following info commands to the chan
			
			my $me = Xchat::get_info('nick');	# Get our current nickname
			my $netname = getnetname();	# Get the current network name
			
			## Count if we have owner|admin|op|halfop|voice on this channel ##
			my $userinfo = Xchat::user_info();	# Get our user info on this channel
			my $meprefix = $userinfo->{'prefix'};	# Grab our user prefix on this channel, to check if we are an op here
			my $pwrprefix = substr $meprefix, 0, 1;	# Grab only the first prefix character (highest power)
			if ((defined $meprefix) && (length($meprefix) > 0)) {	# Check if we have a prefix
				my %mapreplace = (	'+' => "voice",	# Map prefix to key
							'%' => "halfop",
							'@' => "op",
							'&' => "admin",
							'~' => "owner",
							'!' => "owner",
							'*' => "owner",
				);
				my $possibleprefixes = join '', keys %mapreplace;	# Create character class for regex pattern from hash keys
				$pwrprefix =~ s/^([$possibleprefixes])/$mapreplace{$1}/;	# Swap prefix for it's full name: + => "voice"
			} else {	# No prefix, we are a regular chatter
				$pwrprefix = "regular";
			}
			$powercount{$pwrprefix}++;	# Increment hash based on mapped key: $powercount{"voice"}++

			## Count the total number of users on all channels. This value is flawed, as it will count the  ##
			## same nickname more than once, if they are on two or more different channels at the same time ##
			my @Users = Xchat::get_list('users');	# Get an array of all users on the channel in the current context
			$powercount{'user'} += scalar(@Users);	# Add the number of users on the channel to the total number of users 

			## Add unique nicknames to our nickname list and check if we have the power to kick it ##
			my $mynickvalue = prefix2value($meprefix);	# Map our prefix to an access list value
			foreach my $user (@Users) {	# Check each user one at a time
				my $nickname = $user->{nick};	# Get the user's nickname
				if ($nickname ne $me) {	# Make sure we don't count ourselves
					## There may be two different people with the same nick on different networks, so use a network+nickname pair ##
					if (!exists($NetNickList{$netname.$nickname})) {	# We have not seen this nickname on this network yet
						$NetNickList{$netname.$nickname} = 0;	# Add the network+nickname to the list
					}
					my $theirnickvalue = prefix2value($user->{prefix});	# Get the user's channel prefix value
					if (($theirnickvalue <= $mynickvalue) && ($mynickvalue > 3)) {	# Are we op'd, and do we have an equal or higher power than them?
						$NetNickList{$netname.$nickname}++;	# We can kick them on at least one channel we share with them
					}
				}
			}
		}
	}
	
	## Calculate the total number of nicks in our unique nickname list that we can kick on at least one channel ##
	my @uniquenicks = keys(%NetNickList);	# Grab the network+names array
	foreach my $uniquenick (@uniquenicks) {	# Check each nick
		$powercount{'uniquenicks'}++;	# Add up the total number of unique nicknames
		if ($NetNickList{$uniquenick} > 0) {	# If this nick is tagged as kickable
			$powercount{'kickable'}++;	# Add to our count
		}
	}
				
	Xchat::set_context("$startcontext");	# Return context to active window
	my @outcounts = (	pluraltext($powercount{'network'},"network"),
				pluraltext($powercount{'channel'},"channel"),
				olinecount(),
				pluraltext($powercount{'owner'},"owner"),
				pluraltext($powercount{'admin'},"admin"),
				pluraltext($powercount{'op'},"op"),
				pluraltext($powercount{'halfop'},"halfop"),
				pluraltext($powercount{'voice'},"voice"),
				$powercount{'kickable'},
				$powercount{'uniquenicks'},
				$powercount{'user'}
	);
	my $outformat = "I am connected to %s and joined to %s. I have %s, %s, %s, %s, %s and %s. ";
	$outformat .= "I have connection resetting power over %s out of %s people. ";
	$outformat .= "If I did not check for repeat nicks, or my own nick, I would have assumed a total of %s people.";
	my $outmsg = sprintf($outformat, @outcounts);
	Xchat::command("say $outmsg");

	return Xchat::EAT_ALL;	# Tell XChat we handled the command fully
}

sub prefix2value {
	# Map channel mode prefix to value
	my $prefix = $_[0];
	$prefix = substr $prefix, 0, 1;
	if ((defined $prefix) && (length($prefix) > 0)) {
		my %valuemap = (	'+' => 3,
					'%' => 4,
					'@' => 5,
					'&' => 10,
					'~' => 99,
					'!' => 999,
					'*' => 9999,
		);
		my $keyregex = join '', keys %valuemap;	# Create character class for regex pattern from hash keys
		$prefix =~ s/^([$keyregex]).*/$valuemap{$1}/;	# Substitute prefix for it's value
		return $prefix;
	} else {
		return 1;
	}
}

sub pluraltext {
	# Takes the name of the key
	# Returns the count, and the name of the key with or without an 's' if the word needs to be plural
	my ($keycount, $keyname) = @_;
	if ((!defined $keycount) || ($keycount < 1)) {
		return "no $keyname"."s";	# Return 'no' instead of 0
	} elsif ($keycount == 1) {
		return "$keycount $keyname";
	} else {
		return "$keycount $keyname"."s";
	}
}

sub getnetname {
	my $strnet = Xchat::get_info('network');
	if (!defined($strnet)) {
		$strnet = Xchat::get_info('server');
	}
	return $strnet;
}

## Count o-lines ##
my %OperNets;

# foreach ("Raw Modes", "Channel Mode Generic", "Channel Modes", "Generic Message") { Xchat::hook_print($_, \&printmodes ); }
Xchat::hook_print("Channel Mode Generic", \&usermode );

sub usermode {
	# my $outvar = dump(@_);
	if ($_[0][2] =~ m/o/) {
		my $netname = getnetname();
		if (!defined($netname)) { $netname = "default"; }
		if ($_[0][1] =~ m/[+]/) {
			if (!exists($OperNets{$netname})) {
				$OperNets{$netname} = 1;
			}
		} elsif ($_[0][1] =~ m/[-]/) {
			if (exists($OperNets{$netname})) {
				delete($OperNets{$netname});
			}
		}
	}
	return Xchat::EAT_NONE;
}

sub olinecount {
	my $olines = scalar(keys %OperNets);
	if ((!defined $olines) || ($olines < 1)) {
		return "no olines";
	} elsif ($olines == 1) {
		return "$olines oline";
	} else {
		return "$olines olines";
	}
}

Xchat::print("pkPerl Power Brag v$version loaded.");
