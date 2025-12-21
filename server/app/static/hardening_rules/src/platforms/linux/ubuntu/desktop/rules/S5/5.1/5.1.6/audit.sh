#!/bin/bash

# Check sshd Ciphers configuration
approved_ciphers="chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"
result=$(sshd -T 2>/dev/null | grep -i '^ciphers')

weak_ciphers="3des-cbc|aes128-cbc|aes192-cbc|aes256-cbc|arcfour|arcfour128|arcfour256|blowfish-cbc|cast128-cbc"

if echo "$result" | grep -qE "$weak_ciphers"; then
    echo "FAIL: Weak ciphers detected"
    echo "  $result"
    exit 1
elif [ -z "$result" ]; then
    echo "FAIL: No ciphers configured"
    exit 1
else
    echo "PASS: sshd Ciphers configured"
    echo "  $result"
    exit 0
fi
