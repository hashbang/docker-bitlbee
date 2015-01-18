chown -R bitlbee /var/lib/bitlbee
exec sudo -u bitlbee bitlbee
exec sudo -u bitlbee  stunnel /etc/stunnel/stunnel.conf
