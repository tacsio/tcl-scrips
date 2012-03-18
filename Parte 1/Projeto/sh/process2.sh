#!/bin/bash


ns script8.tcl 

awk '{if($8 == 1) print $0 }' out.tr > out1.tr
awk '{if($8 == 2) print $0 }' out.tr > out2.tr

clear
awk -f genthroughput_sum.awk out1.tr 
echo ""
awk -f genthroughput_sum.awk out2.tr 

awk -f awk/genthroughput.awk out1.tr > tcp
awk -f awk/genthroughput.awk out2.tr > udp


