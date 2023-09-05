#!/bin/bash

# Ensure we are being ran as root
if [ $(id -u) -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if tor is installed
if ! which tor > /dev/null; then
    # Install tor if it's not installed
    apt update
    apt install -y tor
fi

# Show a message box while the script runs
echo "This script will install Anonsurf on your system.\nPlease click 'OK' to continue."

# For upgrades and sanity check, remove any existing i2p.list file
rm -f /etc/apt/sources.list.d/i2p.list

# Compile the i2p ppa
echo "deb https://deb.i2p2.de/ unstable main" > /etc/apt/sources.list.d/i2p.list # Default config reads repos from sources.list.d
wget --no-check-certificate -O /tmp/i2p-archive-keyring.gpg https://geti2p.net/_static/i2p-archive-keyring.gpg # Get the latest i2p repo pubkey
apt-key add /tmp/i2p-archive-keyring.gpg # Import the key
rm /tmp/i2p-archive-keyring.gpg # delete the temp key
apt update # Update repos

apt install -y secure-delete i2p # install dependencies, just in case

# Configure and install the .deb
dpkg-deb -b kali-anonsurf-deb-src/ kali-anonsurf.deb # Build the deb package
dpkg -i kali-anonsurf.deb || (apt -f install && dpkg -i kali-anonsurf.deb) # this will automatically install the required packages

# Show a message box to indicate the installation is complete
echo "Anonsurf has been installed on your system."

exit 0
