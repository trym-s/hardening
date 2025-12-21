# 2.1.21 Ensure X window server services are not in use (Automated)

## Description
The X Window System provides a framework for graphical user interfaces.

## Rationale
Unless GUI is required, X Window server should not be installed on servers.

## Audit
```bash
dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' xserver-xorg*
```

## Remediation
```bash
apt purge xserver-xorg*
```
