use IO::Socket;
use strict;

my $host = '127.0.0.1';
my $port = 5038;

# Connect to AMI
my $socket = IO::Socket::INET->new(PeerAddr => $host, PeerPort => $port, Proto => 'tcp') 
             or die "Could not connect to AMI";

# Login
print $socket "Action: Login\r\n";
print $socket "Username: admin\r\n";
print $socket "Secret: yourpassword\r\n\r\n";

# Originate Call
print $socket "Action: Originate\r\n";
print $socket "Channel: PJSIP/101\r\n"; # The internal extension to ring first
print $socket "Context: default\r\n";   # The context in extensions.conf
print $socket "Exten: 100\r\n";         # The extension to connect them to (our AGI script)
print $socket "Priority: 1\r\n";
print $socket "Callerid: WebClick\r\n\r\n";

# Logoff
print $socket "Action: Logoff\r\n\r\n";
close $socket;