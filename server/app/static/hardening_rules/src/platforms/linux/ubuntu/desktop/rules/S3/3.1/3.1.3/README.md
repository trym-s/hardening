# 3.1.3 Ensure bluetooth services are not in use (Automated)

## Description
Bluetooth is a short-range wireless technology standard that is used for exchanging data between devices over short distances.

## Rationale
Bluetooth can be used as a vector for malware or unauthorized remote access devices. If Bluetooth is not required, it should be disabled.

## Audit
Run the following commands to verify Bluetooth is not in use:
```bash
# Check if bluetooth service is enabled
systemctl is-enabled bluetooth.service 2>/dev/null

# Check if bluetooth packages are installed
dpkg -l | grep -E 'bluez|bluetooth'
```
The service should be disabled/masked or the package should not be installed.

## Remediation
Run the following commands to disable Bluetooth:
```bash
# Stop and disable the bluetooth service
systemctl stop bluetooth.service
systemctl disable bluetooth.service
systemctl mask bluetooth.service

# Optionally remove bluetooth packages
apt purge bluez -y
```
