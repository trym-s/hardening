# 1.5.5 Ensure Automatic Error Reporting is not enabled (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
The Apport Error Reporting Service automatically generates crash reports for debugging.

## Rationale
Apport collects potentially sensitive data, such as core dumps, stack traces, and log files. They can contain passwords, credit card numbers, serial numbers, and other private material.

## Audit
1. Verify that the Apport Error Reporting Service is not enabled:
```bash
dpkg-query -s apport &> /dev/null && grep -Psi -- '^\h*enabled\h*=\h*[^0]\b' /etc/default/apport
```
Nothing should be returned.

2. Verify that the apport service is not active:
```bash
systemctl is-active apport.service | grep '^active'
```
Nothing should be returned.

## Remediation
**Option 1: Disable Apport**

1. Edit `/etc/default/apport` and add or edit the enabled parameter:
```
enabled=0
```

2. Stop and mask the apport service:
```bash
systemctl stop apport.service
systemctl mask apport.service
```

**Option 2: Remove Apport**

Run the following command to remove the apport package:
```bash
apt purge apport
```

## Default Value
`enabled=1`

## CIS Controls

| Controls Version | Control | IG 1 | IG 2 | IG 3 |
|------------------|---------|------|------|------|
| v8 | 4.8 Uninstall or Disable Unnecessary Services on Enterprise Assets and Software | | ● | ● |
| v7 | 9.2 Ensure Only Approved Ports, Protocols and Services Are Running | | ● | ● |
