How to Verify the Full Stack Now
Since the logs show Asterisk is ready and Apache was previously "resuming normal operations," let’s verify the connection between all your parts.

1. Test Apache & CGI
Open your web browser and go to: http://localhost/cgi-bin/dashboard.pl

If it works: Your CGI and Apache are perfect.

If it shows "500 Internal Server Error": It’s almost certainly Windows Line Endings. Run this: docker exec -it asterisk-ivr sed -i 's/\r$//' /usr/lib/cgi-bin/dashboard.pl

2. Test AGI (Dialplan)
Inside the container, check if Asterisk sees your Perl script:

Bash

docker exec -it asterisk-ivr ls -l /var/lib/asterisk/agi-bin/hello-world.pl
Make sure it says -rwxr-xr-x. If it doesn't have the x, it won't run.

3. Test AMI (Manager)
Run this command from your host terminal to see if the Manager port is actually listening:

Bash

telnet localhost 5038
(If it connects and says Asterisk Call Manager/X.X.X, your Perl scripts can successfully control Asterisk).