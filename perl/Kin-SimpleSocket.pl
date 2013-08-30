#!/usr/bin/perl

######## Kin's Simple Xchat Socket Example (req) ########
######## 2013-08-30 irc.GeekShed.net #ReaperCon  ########

##   A request by dutch irc.geekshed.net #Script-Help  ##
my $examplehost = 'http://bloomberg.econoday.com/byday.asp?caltype=0';

use strict;
use warnings;
use LWP::Simple;

# 2013-08-30 v1.0 Simple start

# USAGE: /simplesocket

my $version = '1.0';

Xchat::register("SimpleSocket", $version, "Kin's SimpleSocket $version", "");

Xchat::hook_command("SimpleSocket", \&SimpleSocket );

sub SimpleSocket {
	# Get the page
	my $pagedata;
	unless ($pagedata = get($examplehost)) {	# Load page into variable
	## unless (getstore($examplehost, 'temp.html')) {	# alternatively, save to file
		Xchat::print("SimpleSocket FAIL.");
	}

	# Parse the page for events
	my @backrefs = $pagedata =~ m/>(\d+:\d+ [AP]M)&#160;.*?<a href="([^>]+#top)">([^<]+)/g;
	my $totalevents = int(@backrefs / 3);
	Xchat::print("Found $totalevents events at $examplehost");

	# List each event
	for (my $i = 0; $i < @backrefs; $i += 3) {
		# Slice Array 
		my ($time, $link, $title) = @backrefs[$i..$i+2];
		# Cleanup captured data for presentation
		$title =~ s/&#160;$//;
		$link =~ s/^/http:\/\/bloomberg.econoday.com\//;
		Xchat::print("Found an event starting at $time entitled: $title -> $link");
	}

	Xchat::print("SimpleSocket Done.");

	return Xchat::EAT_ALL;
}

Xchat::print("SimpleSocket $version loaded");
