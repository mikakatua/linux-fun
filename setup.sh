#!/bin/bash
RHEL7_ISO="rhel-server-7.5-x86_64-dvd.iso"
ROOT_PASS="master10"
USER_NAME="student"
USER_PASS="go4it"
DOMAIN="example.com"

# Set host name
hostnamectl --static set-hostname $1.$DOMAIN

# Change root password
echo root:$ROOT_PASS | chpasswd

# Create student user
useradd -m $USER_NAME
echo $USER_NAME:$USER_PASS | chpasswd

# Enable SSH password authentication
sed -i '/PasswordAuthentication no/d' /etc/ssh/sshd_config
systemctl restart sshd

case $1 in
server*)
  # Mount RHEL 7 DVD ISO
  mkdir -p /mnt/rhel7_iso
  echo "vagrant /vagrant vboxsf defaults 0 0" >> /etc/fstab
  echo "/vagrant/$RHEL7_ISO /mnt/rhel7_iso iso9660 loop,ro 0 0" >> /etc/fstab
  mount /mnt/rhel7_iso

  # Create RHEL 7 DVD repo
  cat >/etc/yum.repos.d/rhel7-dvd.repo <<EOD
[rhel7-dvd]
name=RHEL 7 DVD 
baseurl=file:///mnt/rhel7_iso
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
enabled=1
EOD
  
  # Install & start Apache
  yum -y install httpd
  systemctl start httpd
  systemctl enable httpd

  # Setup HTTP repo
  ln -s /mnt/rhel7_iso /var/www/html

  # Install & start dnsmasq
  yum -y install dnsmasq
  systemctl start httpd
  systemctl enable dnsmasq
  
  # Populate /etc/hosts
  echo "10.100.0.254 server1" >> /etc/hosts
  for i in $(seq 1 20)
  do
    echo 10.100.0.$i station$i
  done >> /etc/hosts 

  # Setup dnsmasq
  mv /etc/dnsmasq.conf /etc/dnsmasq.conf-orig
  cat > /etc/dnsmasq.conf <<EOD
domain-needed
no-resolv

domain=$DOMAIN
expand-hosts
local=/$DOMAIN/

server=8.8.8.8
server=8.8.4.4
EOD
  systemctl restart dnsmasq 

  # Disable firewall
  systemctl stop firewalld
  systemctl disable firewalld
  
  # Reconfigure network
  nmcli con mod "System eth0" ipv4.dns "" ipv4.ignore-auto-dns yes
  nmcli con mod "System eth1" ipv4.dns "127.0.0.1"
  systemctl restart network
  ;;

station*) 
  # Add server repo
  cat >/etc/yum.repos.d/rhel7-dvd.repo <<EOD
[rhel7-dvd]
name=RHEL 7 DVD 
baseurl=http://server1/rhel7_iso
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
enabled=1
EOD

  # Script to run the labs
  curl -so /usr/local/bin/labs.sh "https://raw.githubusercontent.com/mikakatua/linux-fun/master/labs.sh"
  chmod a+x /usr/local/bin/labs.sh

  # Reconfigure network
  nmcli con mod "System eth0" ipv4.dns "" ipv4.ignore-auto-dns yes
  nmcli con mod "System eth1" ipv4.dns "10.100.0.254"
  systemctl restart network
  ;;
esac
