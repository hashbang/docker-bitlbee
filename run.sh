chown -R bitlbee /var/lib/bitlbee
echo "Starting Bitlbee..."
bitlbee
echo "Starting Stunnel..."
exec sudo -u bitlbee stunnel /etc/stunnel/stunnel.conf
