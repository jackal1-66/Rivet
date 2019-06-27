$!/bin/sh
run-pythia -o Pythia8.fifo -n 500 -e 7000 -c "SoftQCD:all on" -r 202 >Pythia_stage1.log &;
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 Pythia8.fifo -p Pythia8.0.yoda -o Pythia8.1.yoda -n 500 >RivetPythia8.1.log &;
run-pythia -o Pythia8.fifo -n 500 -e 7000 -c "SoftQCD:all on" -r 202 >Pythia_stage1.log &;
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 Pythia8.fifo -p Pythia8.0.yoda -o Pythia8.1.yoda -n 500 >RivetPythia8.1.log &;
run-pythia -o Pythia8.fifo -n 500 -e 7000 -c "SoftQCD:all on" -r 202 >Pythia_stage1.log &;
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 Pythia8.fifo -p Pythia8.0.yoda -o Pythia8.1.yoda -n 500 >RivetPythia8.1.log &;
run-pythia -o Pythia8.fifo -n 500 -e 7000 -c "SoftQCD:all on" -r 202 >Pythia_stage1.log &;
rivet --ignore-beams --pwd -a ALICE_2017_I1511870 Pythia8.fifo -p Pythia8.0.yoda -o Pythia8.1.yoda -n 500 >RivetPythia8.1.log &;

