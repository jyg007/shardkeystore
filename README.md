
# Shard Key store for OSO integration

This code sample is an example how to create a shard key store within OSO if you are considering using an MPC shardkeystore.

## build/

This directory allows to build the Shard keystore container


## contractgenerator/

This directory contains the shardkeystore contract generator.  Terraform is not required

1/ Edit terraforms.tfvars  
2/ create_contract_shell.sh creates the contract in install directory
3/ install directory can be copied to the target host.

IBM HPVS must be preinsalled as /var/lib/libvirt/images/hpcr.2.2.2

	virsh define domain_shardkeystore.xml  creates the KVM guest.  Adjust network definition in the xml file and network-config if necessary.

	Create a data disk for persistent storage
	qemu-img create -f qcow2 /var/lib/libvirt/images/shardkeystore-data.qcow2 10G

	create-cloudinit.sh installs the contract

## dockercompose/

Allows to start the built mpc shardkeystore

## src/

Build mpc shardkeystore binary there.

## test/

Tooling for testing the shardkeystore.

