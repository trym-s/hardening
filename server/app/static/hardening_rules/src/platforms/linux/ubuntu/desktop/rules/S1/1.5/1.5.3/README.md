# 1.5.3 Ensure core dumps are restricted (Automated)

## Profile Applicability
- Level 1 - Server
- Level 1 - Workstation

## Description
A core dump is the memory of an executable program. It is generally used to determine why a program aborted. It can also be used to glean confidential information from a core file. The system provides the ability to set a soft limit for core dumps, but this can be overridden by the user.

## Rationale
Setting a hard limit on core dumps prevents users from overriding the soft variable. If core dumps are required, consider setting limits for user groups (see `limits.conf(5)`). In addition, setting the `fs.suid_dumpable` variable to `0` will prevent setuid programs from dumping core.

## Audit
Run the following commands to verify:

1. Check hard core limit:
```bash
grep -Ps -- '^\h*\*\h+hard\h+core\h+0\b' /etc/security/limits.conf /etc/security/limits.d/*
```
Expected output: `* hard core 0`

2. Check `fs.suid_dumpable` kernel parameter:
```bash
sysctl fs.suid_dumpable
```
Expected output: `fs.suid_dumpable = 0`

3. Check if systemd-coredump is installed:
```bash
systemctl list-unit-files | grep coredump
```
If anything is returned, systemd-coredump is installed and requires additional configuration.

## Remediation
1. Add the following line to `/etc/security/limits.conf` or a `/etc/security/limits.d/*` file:
```
* hard core 0
```

2. Set the following parameter in `/etc/sysctl.conf` or a file in `/etc/sysctl.d/` ending in `.conf`:
```
fs.suid_dumpable = 0
```

3. Run the following command to set the active kernel parameter:
```bash
sysctl -w fs.suid_dumpable=0
```

4. **IF systemd-coredump is installed**, edit `/etc/systemd/coredump.conf` and add/modify the following lines:
```
Storage=none
ProcessSizeMax=0
```
Then run:
```bash
systemctl daemon-reload
```

## References
1. NIST SP 800-53 Rev. 5: CM-6

## MITRE ATT&CK Mappings
| Techniques / Sub-techniques | Tactics | Mitigations |
|------------------------------|---------|-------------|
| T1005, T1005.000             | TA0007  | M1057       |
