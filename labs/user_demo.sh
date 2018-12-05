#!/bin/bash

# Create groups with specific GID
groupadd -g 5000 developer
groupadd -g 5001 dba

# Create a system group (lower GID<1000)
groupadd -r backup

# Create a user with supplementary groups
# A group with the same name as the user will also be created
useradd -c "Waldo Developer" -G developer waldo

# Set the user password. Read it from STDIN
echo secret | passwd waldo --stdin

# Set password expiration in 120 days
chage -M 120 waldo

# To list password aging use
# chage -l waldo

# Create a system user (lower UID<1000) without login shell
useradd -c "Operator" -r -g backup -G dba -M -d / -s /sbin/nologin sysop

# Create a user with specific UID and the home in /opt
# A group with the same name as the user will also be created
useradd -c "Power User" -u 2001 -G backup,developer,dba -b /opt super

# Set the user password. Read it from STDIN
echo p0w3rU | passwd super --stdin
