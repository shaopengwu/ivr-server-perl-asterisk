#!/bin/bash
set -e

# Fix potential Windows line endings and permissions on mounted scripts
# find /usr/lib/cgi-bin /var/lib/asterisk/agi-bin -name "*.pl" -exec sed -i 's/\r$//' {} +
# find /usr/lib/cgi-bin /var/lib/asterisk/agi-bin -name "*.pl" -exec chmod +x {} +

# Refresh Oracle Library Cache
ldconfig

# Start Apache in background
service apache2 start

# Start Asterisk in foreground and replace shell as PID 1
echo "Starting Asterisk IVR Server..."
exec /usr/sbin/asterisk -fvvvg