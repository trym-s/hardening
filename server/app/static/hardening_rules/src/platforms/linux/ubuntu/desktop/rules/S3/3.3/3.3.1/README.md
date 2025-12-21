# 3.3.1 Ensure IP forwarding is disabled (Automated)

## Description
The net.ipv4.ip_forward and net.ipv6.conf.all.forwarding flags are used to tell the system whether it can forward packets or not.

## Rationale
Setting the flags to 0 ensures that a system with multiple interfaces (for example, a hard proxy) does not forward packets from one network to another. This is a critical security measure unless the system is specifically designated as a router.

## Audit
Run the following commands to verify IP forwarding is disabled:
```bash
sysctl net.ipv4.ip_forward
sysctl net.ipv6.conf.all.forwarding
```
Both should return `0`.

## Remediation
Run the following commands to disable IP forwarding:
```bash
# Set sysctl parameters
sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv6.conf.all.forwarding=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1

# Make persistent
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv6.conf.all.forwarding = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf
```
