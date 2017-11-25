#!/bin/bash
#

##
## QoS pour eth0
##

echo ""
echo -n "QoS sur eth0 , "
date
## affiche classes
echo "** Anciennes classes tc:"
tc class show dev eth0
tc qdisc show dev eth0

## efface classes et gestionnaires
tc qdisc del dev eth0 root >/dev/null 2>&1

## affiche classes
echo "** Classes tc par defaut:"
tc class show dev eth0
tc qdisc show dev eth0


## l equilibrage serait peut etre bien en gre, et encore ce n est pas certain...
## en tunnel ssh ce n est pas bien en tout cas : d'une part il est non prioritaire,
## d autre part de multiples flux passent a l interieur d un seul, et l equilibrer
## avec des flux individuels serait probablement catastrophique...


## root => classes prio : 1:1 1:2 1:3
tc qdisc add dev eth0 root handle 1: prio

## classe 1:1 => gestionnaire sfq 10:
tc qdisc add dev eth0 parent 1:1 handle 10: sfq perturb 10

## classe 1:2 => gestionnaire sfq 20:
tc qdisc add dev eth0 parent 1:2 handle 20: sfq perturb 10

## classe 1:3 => gestionnaire sfq 30:
tc qdisc add dev eth0 parent 1:3 handle 30: sfq perturb 10


## affiche classes
echo "** Nouvelles classes tc:"
tc class show dev eth0  
tc qdisc show dev eth0  

## stats sur les classes
echo "Stats: tc -s qdisc ls dev eth0"
tc -s qdisc ls dev eth0

echo ""
exit 0
