#!/bin/bash

# 6.1.3.7 Ensure rsyslog is not configured to receive logs from a remote client (Automated)

echo "Checking if rsyslog is configured to receive logs from remote clients..."

# Check for TCP reception
tcp_input=$(grep -E '^\$ModLoad imtcp|^module\(load="imtcp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)
tcp_port=$(grep -E '^\$InputTCPServerRun|^input\(type="imtcp"' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)

# Check for UDP reception
udp_input=$(grep -E '^\$ModLoad imudp|^module\(load="imudp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)
udp_port=$(grep -E '^\$UDPServerRun|^input\(type="imudp"' /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null)

if [ -z "$tcp_input" ] && [ -z "$tcp_port" ] && [ -z "$udp_input" ] && [ -z "$udp_port" ]; then
    echo "PASS: rsyslog is not configured to receive logs from remote clients"
    exit 0
else
    echo "FAIL: rsyslog is configured to receive logs from remote clients"
    echo "TCP input module: ${tcp_input:-Not loaded}"
    echo "TCP port config: ${tcp_port:-Not configured}"
    echo "UDP input module: ${udp_input:-Not loaded}"
    echo "UDP port config: ${udp_port:-Not configured}"
    exit 1
fi
