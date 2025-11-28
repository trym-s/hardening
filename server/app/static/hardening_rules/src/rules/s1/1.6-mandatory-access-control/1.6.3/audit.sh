#!/bin/bash
if aa-status | grep -q "0 profiles are in complain mode" && aa-status | grep -q "0 processes are unconfined"; then
    echo "All AppArmor profiles are enforcing"
    exit 0
else
    echo "Some AppArmor profiles are NOT enforcing"
    exit 1
fi
