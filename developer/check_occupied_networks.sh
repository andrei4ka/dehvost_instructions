#!/bin/bash
echo
echo "These networsk are taken already:"
for net in `virsh net-list | grep system_test | awk '{print $1}'` ; do virsh net-dumpxml $net | grep 'ip address' | grep -o '[[:digit:]]\+\.[[:digit:]]\+\.'; done | sort -u | xargs -I {} echo "{}0.0/16"
echo
