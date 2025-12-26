#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $host = "172.16.1.167";
# my $sid  = "IMSCOND1";
my $sid  = "ALDIDEV1.DEV";
my $user = "embeds";
my $pass = "i8ab4u";

# Attempt to connect
my $dsn = "DBI:Oracle:host=$host;service_name=$sid";
# my $dsn = "DBI:Oracle:host=$host;sid=$sid";
my $dbh = DBI->connect($dsn, $user, $pass) 
    or die "Connection Error: $DBI::errstr";

print "Successfully connected to Oracle Database!\n";
$dbh->disconnect();