#!/bin/bash

#Monash
run-pythia -n 1000000 -o /tmp/p8R3.fifo -e 13000 -c "SoftQCD:all on" &>Pythiapp1e6R3.log &
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 /tmp/p8R3.fifo -o pythia8pp1e6R3.yoda -n 1000000 &>RivetPythia8pp1e6R3.log &
#Mode0
run-pythia -n 1000000 -o /tmp/p80R3.fifo -e 13000 -c "SoftQCD:all on" -i mode0.par &>Pythiapp1e6mode0R3.log &
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 /tmp/p80R3.fifo -o pythia8pp1e6mode0R3.yoda -n 1000000 &>RivetPythia8pp1e6mode0R3.log &
#Mode2
run-pythia -n 1000000 -o /tmp/p82R3.fifo -e 13000 -c "SoftQCD:all on" -i mode2.par &>Pythiapp1e6mode2R3.log &
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 /tmp/p82R3.fifo -o pythia8pp1e6mode2R3.yoda -n 1000000 &>RivetPythia8pp1e6mode2R3.log &


