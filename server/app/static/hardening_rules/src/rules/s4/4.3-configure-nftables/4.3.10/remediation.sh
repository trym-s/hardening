#!/bin/bash
# 4.3.10 Ensure nftables rules are permanent

# This depends on the distro, assuming Debian/Ubuntu style or generic
nft list ruleset > /etc/nftables.conf
