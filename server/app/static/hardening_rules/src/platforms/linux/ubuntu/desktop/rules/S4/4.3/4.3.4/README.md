# 4.3.4 Ensure a nftables table exists (Automated)

## Description
nftables requires at least one table to hold chains and rules.

## Rationale
Tables are containers for chains and rules in nftables.

## Audit
```bash
nft list tables
```
Should show at least one table.

## Remediation
```bash
nft create table inet filter
```
