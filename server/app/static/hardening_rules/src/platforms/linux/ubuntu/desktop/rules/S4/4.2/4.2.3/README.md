# 4.2.3 Ensure ufw service is enabled (Automated)

## Description
Enable the ufw service to protect the system with the firewall.

## Rationale
The ufw service must be enabled and running to enforce firewall rules.

## Audit
```bash
systemctl is-enabled ufw.service
ufw status
```
Service should be enabled and ufw should show "Status: active".

## Remediation
```bash
systemctl unmask ufw.service
systemctl enable ufw.service
systemctl start ufw.service
ufw enable
```
