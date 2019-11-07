#!/bin/bash
for i in {0..4}
do 
	rivet --ignore-beams --pwd -a ALICE_2017_I1511870 Herwig7."$i".fifo -o Herwig1e7new."$i".yoda -n 2000000 >RivetHerwig7."$i".log &
done
