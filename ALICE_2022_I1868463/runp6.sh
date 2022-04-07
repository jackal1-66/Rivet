#!/bin/bash

#Default Pythia6
aligenmc -N 1000000 -o /tmp/p6def.fifo &>pythia6def1e6.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/p6def.fifo -o pythia6pp1e6.yoda -n 1000000 &>RivetPythia6pp1e6.log &
#Pythia6 Perugia11
aligenmc -t 350 -N 1000000 -o /tmp/p6per.fifo &>pythia6per1e6.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/p6per.fifo -o pythia6pp1e6Per11.yoda -n 1000000 &>RivetPythia6pp1e6Per11.log &


