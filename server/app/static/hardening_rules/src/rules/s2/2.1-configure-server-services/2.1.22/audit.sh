#!/bin/bash
# 2.1.22 Ensure only approved services are listening on a network interface

echo "Reviewing listening ports:"
ss -lntu

echo "WARNING: This rule requires manual verification of approved services."
exit 0
