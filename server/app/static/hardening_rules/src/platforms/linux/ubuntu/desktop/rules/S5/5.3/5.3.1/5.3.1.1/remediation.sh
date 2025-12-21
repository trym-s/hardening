#!/bin/bash

# Update pam to latest version
echo "Updating libpam-runtime..."
apt update && apt upgrade libpam-runtime -y
echo "SUCCESS: libpam-runtime updated"
