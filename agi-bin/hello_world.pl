#!/usr/bin/perl
use strict;
use warnings;
use Asterisk::AGI;

# Initialize the AGI object
my $AGI = new Asterisk::AGI;

# Grab the variables passed by Asterisk
my %input = $AGI->ReadParse();

# 1. Answer the call
$AGI->answer();

# 2. Say a greeting (uses the built-in Asterisk sounds)
# This will play "hello-world" and "thank-you"
$AGI->stream_file('hello-world');
$AGI->say_digits(123);

# 3. Log to the Asterisk console
$AGI->verbose("AGI Script executed successfully!", 3);

# 4. Hang up
$AGI->hangup();

exit;