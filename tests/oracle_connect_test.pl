#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $host = "172.16.1.167";
# my $sid  = "IMSCOND1";
my $service_name  = "ALDIDEV1.DEV";
my $user = "***";
my $pass = "****";

# Attempt to connect
my $dsn = "DBI:Oracle:host=$host;service_name=$service_name";
# my $dsn = "DBI:Oracle:host=$host;sid=$sid";
my $dbh = DBI->connect($dsn, $user, $pass) 
    or die "Connection Error: $DBI::errstr";

print "Successfully connected to Oracle Database!\n";
$dbh->disconnect();