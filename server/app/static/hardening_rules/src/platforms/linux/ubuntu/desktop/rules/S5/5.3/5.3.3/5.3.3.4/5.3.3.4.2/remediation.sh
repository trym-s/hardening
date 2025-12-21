#!/bin/bash

# Remove remember from pam_unix
echo "Removing remember from pam_unix..."

sed -i 's/\s*remember=[0-9]*//g' /etc/pam.d/common-password

echo "SUCCESS: remember removed from pam_unix"
echo "Note: Password history should be configured via pam_pwhistory (5.3.3.3.1)"
