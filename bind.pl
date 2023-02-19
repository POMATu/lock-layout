#!/usr/bin/env perl

use strict;
use warnings;

my @blacklist = ('VNC Viewer');
my @whitelist = ();
my $force_input_source = 0; # index of input source to force
my $secondary_input_source = 1;

#my $active_title = `xdotool getwindowfocus getwindowname`; # another slow laggy method for Poettering soyboy fans
my $active_title = `xprop -id \$(xprop -root 32x '\t\$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME`;
#chomp($active_title);
print $active_title; #. "\n";

POETTERING: foreach (@blacklist) {
	if (index($active_title, $_) != -1) {
		foreach (@whitelist) {
			if (index($active_title, $_) != -1) {
				next POETTERING;
			}
		}
		system('gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval  "imports.ui.status.keyboard.getInputSourceManager().inputSources['.$force_input_source.'].activate()"');
		print("Executed FORCED layout change\n");
		exit;
	}
}

my $check = `gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "imports.ui.status.keyboard.getInputSourceManager().currentSource.index"`;

if (index($check, "'".$force_input_source."'") != -1) {
	system('gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval  "imports.ui.status.keyboard.getInputSourceManager().inputSources['.$secondary_input_source.'].activate()"');
	print("Executed REGULAR layout change\n");		
} else {
	system('gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval  "imports.ui.status.keyboard.getInputSourceManager().inputSources['.$force_input_source.'].activate()"');
	print("Executed REGULAR layout change\n");
}