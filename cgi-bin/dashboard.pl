#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $q = CGI->new;

# Print the required HTTP header
print $q->header('text/html');

# Print a simple HTML page
print $q->start_html("IVR Dashboard");
print $q->h1("IVR Server Status");
print $q->p("Server Time: " . scalar(localtime));

# Run a system command to check if Asterisk is running
my $status = `pgrep asterisk` ? "Running" : "Stopped";
print $q->p("Asterisk Service: <b>$status</b>");

print $q->end_html;