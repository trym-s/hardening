#!/bin/bash
# 2.1.15 Ensure snmp services are not in use

systemctl stop snmpd
systemctl disable snmpd
apt purge snmpd -y
