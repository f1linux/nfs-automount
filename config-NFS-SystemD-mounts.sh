#!/bin/bash

#set -x

echo
echo "$(tput setaf 5)#######   VERSIONING & ATTRIBUTION   #######$(tput sgr 0)"
echo
echo '# Script Author:	Terrence Houlahan, Linux & Network Engineer F1Linux.com'
echo '# Author Site:		http://www.F1Linux.com'
echo
echo '# Script Version:	1.00.00'
echo '# Script Date:		20230916'

echo
echo '# These scripts and others by the author can be found at:'
echo
echo '	https://github.com/f1linux'
echo

echo
echo "$(tput setaf 5)#######   LICENSE: GPL Version 3   #######$(tput sgr 0)"
echo "$(tput setaf 5)# Copyright (C) 2021 Terrence Houlahan$(tput sgr 0)"
echo

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, [see](https://www.gnu.org/licenses/)

# Full LICENSE found [HERE](./LICENSE)


#######   INSTRUCTIONS   #######

# This script mounts an NFS folder to the path '/mnt/' per FHS guidance
# with an arbitrary name which is specified in a variable.

# STEP 1:	Modify variables in "SET VARIABLES" section below

# STEP 2:	Execute this script as the 'ubuntu' user:
#			sudo ./config-NFS-SystemD-mounts.sh


#######   SET VARIABLES   #######

# The script will create the folder with the name supplied in "NFSMOUNTFOLDER" variable
# in the path /mnt. Therefore do NOT manually create the folder the NFS share is mounted to.
#
# NAMING REQUIREMENTS: Do NOT specify a folder name with a hyphen in folder name that the NFS folder will be mounted on.
#         This will cause the SystemD mount to fail.
#         ie: "filename" is a valid name and WILL work but "file-name" will NOT and cause the mount to fail
#
NFSMOUNTFOLDER='NFS_Share'

# NFS Folder Path to Mount:
#
# NOTE: Below path uses Synology default "volume1" - their default name for a single/first storage volume
NFSPATH='192.168.1.23:/volume1/Pi4_8GB_Rack1'
FILESYSTEM='nfs4'

# SystemD mount file comment:
# Below variable sets "Description" field in the file that starts the mount.
MOUNTDESCRIPTION='Mount NFS Folder'

# Automount time-out in seconds
#
TIMEOUTIDLESEC='30'

#######   EDIT BELOW WITH CAUTION   #######

## NOTE: Most settings shown below work out of the box


echo "$(tput setaf 5)#######   Install NFS Packages   #######$(tput sgr 0)"
echo


if [[ $(dpkg -l | grep "nfs-common") = '' ]]; then
	until apt-get -y install nfs-common > /dev/null
	do
		echo "$(tput setaf 3)CTRL +C to exit if failing endlessly$(tput sgr 0)"
		echo
	done
fi



if [[ $(dpkg -l | grep "nfswatch") = '' ]]; then
	until apt-get -y install nfswatch > /dev/null
	do
		echo "$(tput setaf 3)CTRL +C to exit if failing endlessly$(tput sgr 0)"
		echo
	done
fi


echo "$(tput setaf 5)#######   CREATE SYSTEMD MOUNT FOR NFS Folder   #######$(tput sgr 0)"
echo

echo "$(tput setaf 5)# Create directory /mnt/$NFSMOUNTFOLDER for the NFS folder to mount to$(tput sgr 0)"

if [ ! -d /mnt/$NFSMOUNTFOLDER ]; then

	mkdir /mnt/$NFSMOUNTFOLDER
	chmod 770 /mnt/$NFSMOUNTFOLDER

fi

echo "$(tput setaf 5)# Create mnt-$NFSMOUNTFOLDER.mount$(tput sgr 0)"
echo

if [ ! -f /etc/systemd/system/mnt-$NFSMOUNTFOLDER.mount ]; then

cat <<EOF> /etc/systemd/system/mnt-$NFSMOUNTFOLDER.mount
[Unit]
Description=$MOUNTDESCRIPTION
After=network-online.target
DefaultDependencies=no

[Mount]
What=$NFSPATH
Where=/mnt/$NFSMOUNTFOLDER
Type=$FILESYSTEM
Options=defaults
StandardOutput=journal

[Install]
WantedBy=multi-user.target

EOF

chown root:root /etc/systemd/system/mnt-$NFSMOUNTFOLDER.mount
chmod 644 /etc/systemd/system/mnt-$NFSMOUNTFOLDER.mount

systemctl daemon-reload
systemctl enable mnt-$NFSMOUNTFOLDER.mount
sudo systemctl start mnt-$NFSMOUNTFOLDER.mount

else

	echo "'/etc/systemd/system/mnt-$NFSMOUNTFOLDER.mount' already exists"

fi



echo "$(tput setaf 5)# Create mnt-$NFSMOUNTFOLDER.automount$(tput sgr 0)"
echo

if [ ! -f /etc/systemd/system/mnt-$NFSMOUNTFOLDER.automount ]; then

cat <<EOF> /etc/systemd/system/mnt-$NFSMOUNTFOLDER.automount
[Unit]
Description=$MOUNTDESCRIPTION
Requires=network-online.target
#After=

[Automount]
Where=/mnt/$NFSMOUNTFOLDER
TimeoutIdleSec=$TIMEOUTIDLESEC

[Install]
WantedBy=multi-user.target

EOF

chown root:root /etc/systemd/system/mnt-$NFSMOUNTFOLDER.automount
chmod 644 /etc/systemd/system/mnt-$NFSMOUNTFOLDER.automount

else

	echo "'/etc/systemd/system/mnt-$NFSMOUNTFOLDER.automount' already exists"

fi



echo "$(tput setaf 5)# systemctl status of new NFS Mount$(tput sgr 0)"
echo


systemctl status mnt-$NFSMOUNTFOLDER.mount



echo
echo "$(tput setaf 5)#######   NEXT STEPS:   #######$(tput sgr 0)"
echo
echo 'Reboot and verify that the NFS folder automatically mounts on boot using the "mount" command'
echo
