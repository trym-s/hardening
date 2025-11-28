#!/bin/bash
systemctl unmask dailyaidecheck.service
systemctl unmask dailyaidecheck.timer
systemctl --now enable dailyaidecheck.timer
