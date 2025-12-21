# 3.3.8 Ensure source routed packets are not accepted (Automated)

## Description
In networking, source routing allows a sender to partially or fully specify the route packets take through the network.

## Rationale
Source routing allows a sender to bypass security controls and route packets through an otherwise unauthorized path.

## Audit
```bash
sysctl net.ipv4.conf.all.accept_source_route
sysctl net.ipv4.conf.default.accept_source_route
sysctl net.ipv6.conf.all.accept_source_route
sysctl net.ipv6.conf.default.accept_source_route
```
All should return `0`.

## Remediation
```bash
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv6.conf.all.accept_source_route=0
sysctl -w net.ipv6.conf.default.accept_source_route=0
```
