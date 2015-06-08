#!/bin/bash

. userrc

iptables -t nat -I PREROUTING -p tcp --dport ${SUBNET}80 -j DNAT --to-destination ${POOL}.0.2:8000
iptables -t nat -I PREROUTING -p tcp --dport ${SUBNET}81 -j DNAT --to-destination ${POOL}.1.2:8000
iptables -t nat -I PREROUTING -p tcp --dport ${SUBNET}22 -j DNAT --to-destination ${POOL}.0.2:22
iptables -t nat -I PREROUTING -p tcp --dport ${SUBNET}21 -j DNAT --to-destination ${POOL}.1.2:22
iptables -I FORWARD -p tcp -d ${POOL}.0.0/16 -j ACCEPT



echo
$RED
echo '---------------USER INFORMATION--------------------'
$GREEN
echo Now FUEL should be available by:
$YELLOW
echo  ip:${SUBNET}80 
$RESET
$GREEN
echo Now your FUEL environment accessible by:
$YELLOW 
echo ssh ip -p ${SUBNET}22
$RESET
echo
$YELLOW 
echo MOS network parameters:
$GREEN 
echo Admin network: 10.${SUBNET}.0.0/24
echo Public network: 10.${SUBNET}.1.0/24, Gateway: 10.${SUBNET}.1.1
echo DNS servers: dnss
echo NTP servers: ntpss
$RED
echo '---------------USER INFORMATION--------------------'
$RESET