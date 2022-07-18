#!/bin/bash

# Install latest SML/NJ from source on Ubuntu (20.04)
# Needs to be run as sudo
# https://aamnah.com/notes/install-smlnj-source-ubuntu

# Make directory for SML install
cd /usr/local
mkdir smlnj
cd smlnj

# Download source
# replace 110.99.2 with whatever the latest is at the time of install
wget https://smlnj.org/dist/working/110.99.2/config.tgz

# Extract files
tar -xzf config.tgz

# Install
# -64 is for 64bit architecture. default install is 32bit but you can change that by passing an option
config/install.sh -64

# Update PATH
echo '
# SML/NJ
# Standard ML of New Jersey
# where /usr/local/sml/bin is the install location
export PATH=$PATH:/usr/local/smlnj/bin
' >> ~/.zshrc