#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $host = "<ip address>";
my $sid  = "sid";
my $service_name  = "<servicename>";
my $user = "user";
my $pass = "passwd";

# Attempt to connect
my $dsn = "DBI:Oracle:host=$host;service_name=$service_name;sid=$sid";
# my $dsn = "DBI:Oracle:host=$host;sid=$sid";
my $dbh = DBI->connect($dsn, $user, $pass) 
    or die "Connection Error: $DBI::errstr";

print "Successfully connected to Oracle Database!\n";
# Test a simple query
my $sql = "SELECT 'Connection Verified' FROM DUAL";
my $sth = $dbh->prepare($sql);
$sth->execute();

while (my @row = $sth->fetchrow_array) {
    print "Database says: $row[0]\n";
}

$dbh->disconnect();