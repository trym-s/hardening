# 5.1.3 Ensure permissions on SSH public host key files are configured (Automated)

## Description
An SSH public key is one of two files used in SSH public key authentication. The public key can be used to verify the authenticity of the SSH server.

## Rationale
If a public host key file is modified by an unauthorized user, the SSH server could be compromised.

## Audit
```bash
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat -Lc "%n %a %u %g" {} +
```
All files should have permissions `644` or more restrictive with owner and group as `root:root`.

## Remediation
```bash
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 644 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;
```
