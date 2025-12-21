# 2.4.2.1 Ensure at is restricted to authorized users (Automated)

## Description
The at command schedules a one-time task for a particular time. Access to at should be restricted to authorized users.

## Rationale
Configure at to allow only authorized users to schedule one-time jobs. This helps prevent unauthorized users from gaining access to system resources or escalating privileges.

If `/etc/at.allow` exists, only users listed in this file can use at. If `/etc/at.allow` does not exist, `/etc/at.deny` is checked and users NOT listed in at.deny can use at. Using at.allow (whitelist) is preferred over at.deny (blacklist).

**Note:** If at is not installed on the system, this control is not applicable.

## Audit
Run the following commands to verify at is restricted to authorized users:

1. Check if at is installed:
```bash
dpkg -l | grep "^ii" | grep " at "
```

2. If at is installed, verify /etc/at.deny does not exist:
```bash
stat /etc/at.deny
```
This should return "No such file or directory"

3. Verify /etc/at.allow exists with correct permissions:
```bash
stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/at.allow
```
Expected: owned by root:root with permissions 640 or more restrictive.

## Remediation
Run the following commands to remove at.deny, create at.allow, and set permissions:
```bash
rm -f /etc/at.deny
touch /etc/at.allow
chown root:root /etc/at.allow
chmod 640 /etc/at.allow
```
