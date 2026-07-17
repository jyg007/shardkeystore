#!/bin/bash

#
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2023
#
# The source code for this program is not published or otherwise
# divested of its trade secrets, irrespective of what has been
# deposited with the U.S. Copyright Office
#

touch vendor-data
echo "local-hostname: shardkeystore" > meta-data

genisoimage -output /var/lib/libvirt/images/shardkeystore-cloudinit -volid cidata -joliet -rock vendor-data user-data meta-data network-config

qemu-img create -f qcow2 /var/lib/libvirt/images/shardkeystore-overlay.qcow2 10G
