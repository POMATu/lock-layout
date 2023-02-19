#!/usr/bin/env perl

use strict;
use warnings;

$SIG{CHLD} = 'IGNORE';
$|=1; # autoflush

my $layout_trigger_event = "org.gnome.desktop.input-sources";

my @whitelist = ('VNC Viewer');
my @blacklist = ();
my $force_input_source = 0; # index of input source to force


open(my $handle, "-|", "dbus-monitor");


while (<$handle>) {
	my $line = $_;
	#print $line; # debugging dbus
	if (index($line, $layout_trigger_event) != -1) {
		#my $active_title = `xdotool getwindowfocus getwindowname`; # another slow laggy method for Poettering soyboy fans
		my $active_title = `xprop -id \$(xprop -root 32x '\t\$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME`;
		print $active_title; 

		POETTERING: foreach (@whitelist) {
			if (index($active_title, $_) != -1) {
				foreach (@blacklist) {
					if (index($active_title, $_) != -1) {
						next POETTERING;
					}
				}
				#my $check = `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "imports.ui.status.keyboard.getInputSourceManager().currentSource.index"`;
				#if (!(index($check, "'0'") != -1)) {
					system('gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval  "imports.ui.status.keyboard.getInputSourceManager().inputSources['.$force_input_source.'].activate()"');
					print("Executed FORCED layout change\n");
				#}
			}
		}
	}
}