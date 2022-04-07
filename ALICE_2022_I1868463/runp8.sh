#!/bin/bash

#Monash
run-pythia -n 1000000 -o /tmp/p8.fifo -e 13000 -c "SoftQCD:all on" >Pythiapp1e6.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/p8.fifo -o pythia8pp1e6.yoda -n 1000000 >RivetPythia8pp1e6.log &
#Mode0
run-pythia -n 1000000 -o /tmp/p80.fifo -e 13000 -c "SoftQCD:all on" -i mode0.par >Pythiapp1e6mode0.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/p80.fifo -o pythia8pp1e6mode0.yoda -n 1000000 >RivetPythia8pp1e6mode0.log &
#Mode2
run-pythia -n 1000000 -o /tmp/p82.fifo -e 13000 -c "SoftQCD:all on" -i mode2.par >Pythiapp1e6mode2.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/p82.fifo -o pythia8pp1e6mode2.yoda -n 1000000 >RivetPythia8pp1e6mode2.log &


