#!/bin/bash

cp /opt/rtpproxy /etc/init.d/rtpproxy

# Set the CONTROL_SOCK
sed -i 's/CONTROL_SOCK="unix:$PIDFILE_DIR#$NAME.sock"/CONTROL_SOCK="udp:127.0.0.1:7722"/' /etc/init.d/rtpproxy

groupadd --system rtpproxy
useradd -s /sbin/nologin --system -g rtpproxy rtpproxy
chmod +x /etc/init.d/rtpproxy
mkdir -p /var/run/rtpproxy
chown -R rtpproxy:rtpproxy -R /var/run/rtpproxy/
systemctl daemon-reload
systemctl start rtpproxy.service

# Set the DBENGINE
sed -i 's/# DBENGINE=MYSQL/DBENGINE=MYSQL/' /usr/local/etc/kamailio/kamctlrc

# Set the DBROOTPW
sed -i 's/# DBROOTPW="dbrootpw"/DBROOTPW="paSSword1*"/' /usr/local/etc/kamailio/kamctlrc

# Set the DBROOTUSER
sed -i 's/# DBROOTUSER="root"/DBROOTUSER="root"/' /usr/local/etc/kamailio/kamctlrc

# Set the DBRWPW
sed -i 's/# DBRWPW="kamailiorw"/DBRWPW="kamailiorw"/' /usr/local/etc/kamailio/kamctlrc

# Set the CHARSET
sed -i 's/#CHARSET="latin1"/CHARSET="latin1"/' /usr/local/etc/kamailio/kamctlrc

# Install presence related tables
sed -i 's/# INSTALL_PRESENCE_TABLES=ask/INSTALL_PRESENCE_TABLES=yes/' /usr/local/etc/kamailio/kamctlrc

# Install tables for the modules in the EXTRA_MODULES variable.
sed -i 's/# INSTALL_EXTRA_TABLES=ask/INSTALL_EXTRA_TABLES=yes/' /usr/local/etc/kamailio/kamctlrc

# If to install uid modules related tables
sed -i 's/# INSTALL_DBUID_TABLES=ask/INSTALL_DBUID_TABLES=yes/' /usr/local/etc/kamailio/kamctlrc

mkdir -p /var/run/mysqld/
touch /var/run/mysqld/mysqld.sock
touch /var/run/mysqld/mysqld.pid
chown -R mysql:mysql /var/run/mysqld/mysqld.sock
chown -R mysql:mysql /var/run/mysqld/mysqld.pid
chmod -R 644 /var/run/mysqld/mysqld.sock

service mysql stop
usermod -d /var/lib/mysql/ mysql
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
service mysql start

kamdbctl create

cp /opt/kamailio-mode-$DEPLOY_MODE.cfg /usr/local/etc/kamailio/kamailio.cfg

sed -i "s/<DISPATCHER_PING_FROM>/$DISPATCHER_PING_FROM/" /usr/local/etc/kamailio/kamailio.cfg

rtpproxy -s udp:127.0.0.1:7722 -m $RTPPROXY_RTP_PORT_MIN -M $RTPPROXY_RTP_PORT_MAX -F


for i in $UAC_ENDPOINTS
do
	kamctl dispatcher add 1 sip:$i 9 0 '' ''
done

sed -i 's/# STARTOPTIONS=/STARTOPTIONS="-DD"/' /usr/local/etc/kamailio/kamctlrc

sed -i "s/# SIP_DOMAIN=kamailio.org/SIP_DOMAIN=$SIP_DOMAIN/" /usr/local/etc/kamailio/kamctlrc

kamctl start

tail -f /dev/null

