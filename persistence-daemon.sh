#!/bin/bash
# -*- coding: utf-8 -*-
#
#  persistence-daemon
#  
#  Copyright 2022 Thomas Castleman <contact@draugeros.org>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#
# check for devices with label "persist"
labels=$(ls /dev/disk/by-partlabel)
device=""
for each in $labels; do
	if [ "${each,,}" == "persist" ] || [ "${each,,}" == "persistent" ]; then
		device="/dev/disk/by-partlabel/$each"
	fi
done
if [ "$device" == "" ]; then
	echo "No persistent partition found. Exiting..."
	exit
fi

# check if partition uses valid fs type
type=$(lsblk "$device" --output fstype --noheadings)
accepted_fs="ext2 ext3 ext4 btrfs xfs jfs f2fs"
if [ "$accepted_fs" == "${accepted_fs/$type/}" ]; then
	echo "Persistent partition uses unsupported filesystem type: $type"
	echo "Accepted filesystems are: ${accepted_fs// /, }"
	exit 1
fi

# mount on /mnt and see if this partition has been used before
mount "$device" /mnt
if [ ! -f /mnt/.persistent ]; then
	# No. This HAS NOT been used before.
	touch /mnt/.persistent
	cp -R /home/* /mnt/
fi

# unmount from /mnt, mount on /home
umount /mnt
mount "$device" /home
