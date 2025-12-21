#!/bin/bash
# CIS 4.3.4 Ensure a nftables table exists

echo "Applying remediation for CIS 4.3.4..."

nft create table inet filter 2>/dev/null || echo "Table may already exist"

echo "Remediation complete for CIS 4.3.4"
