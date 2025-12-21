# 5.1.2 Ensure permissions on SSH private host key files are configured (Automated)

## Description
An SSH private key is one of two files used in SSH public key authentication. The private key is secret and should be protected from unauthorized access.

## Rationale
If an unauthorized user obtains the private SSH host key file, the host could be impersonated.

## Audit
```bash
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec stat -Lc "%n %a %u %g" {} +
```
All files should have permissions `600` with owner and group as `root:root`.

## Remediation
```bash
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 600 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
```
