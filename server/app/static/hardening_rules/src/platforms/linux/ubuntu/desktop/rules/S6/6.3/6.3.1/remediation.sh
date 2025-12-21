#!/bin/bash
echo "Installing AIDE..."
apt-get update
apt-get install -y aide aide-common
echo "Initializing AIDE database (this may take a while)..."
aideinit
mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
echo "AIDE has been installed and initialized"
