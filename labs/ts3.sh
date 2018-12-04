#!/bin/bash
#
# Network problem
#

nmcli con mod "System eth0" ipv4.ignore-auto-routes yes
nmcli con mod "System eth1" ipv4.dns ""
systemctl restart network
