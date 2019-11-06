#!/bin/bash
for i in {0..4}
do
	run-pythia -n $1 -o Pythia8."$i".fifo -e 7000 -c "SoftQCD:all on" -r "$i"0"$i" >Pythiapp1e7new."$i".log &
	rivet --ignore-beams --pwd -a ALICE_2017_I1511870 Pythia8."$i".fifo -o pythia8pp1e7new."$i".yoda -n $1 >RivetPythia8pp1e7new."$i".log &
done	
