#!/bin/bash
# 4.4.3.1 Ensure ip6tables default deny firewall policy

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP
