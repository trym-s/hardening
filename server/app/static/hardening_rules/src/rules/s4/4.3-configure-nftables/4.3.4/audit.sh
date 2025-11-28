#!/bin/bash
# 4.3.4 Ensure a nftables table exists

if nft list tables | grep -q "."; then
    echo "nftables table exists"
    exit 0
else
    echo "No nftables table found"
    exit 1
fi
