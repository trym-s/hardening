#!/bin/bash
# 3.3.3 Ensure bogus icmp responses are ignored

if sysctl net.ipv4.icmp_ignore_bogus_error_responses | grep -q "1"; then
    echo "Bogus ICMP responses are ignored"
    exit 0
else
    echo "Bogus ICMP responses are not ignored"
    exit 1
fi
