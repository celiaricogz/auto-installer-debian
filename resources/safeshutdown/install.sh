cp SafeShutdown /usr/sbin/
cp SafeShutdown.cfg /usr/sbin/
cp safeshutdown-wrapped.sh /usr/sbin/
chmod 755 /usr/sbin/SafeShutdown 
chmod 644 /usr/sbin/SafeShutdown.cfg 
chmod 755 /usr/sbin/safeshutdown-wrapped.sh

cp SafeShutdown.service /etc/systemd/system/SafeShutdown.service
chmod 644 /etc/systemd/system/SafeShutdown.service 

systemctl enable SafeShutdown
systemctl start SafeShutdown


