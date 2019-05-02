# Rivet guide to start

Make a directory for the analysis 
•	enter into the directory

$  rivet-mkanalysis ALICE_2018_I1672806 

Then run
$  rivet-buildplugin RivetALICE_2018_I1672806.so ALICE_2018_I1672806.cc 

Run source code on Pythia (.hepmc) data file for 100 events (for example)
$ rivet --ignore-beams --pwd -a ALICE_2018_I1672806 ../TEST-pythia/pythia8.pbpb2760.hepmc -o rivet.yoda -n 100

Make Rivet plots  
$ rivet-mkhtml --pwd --errs rivet.yoda

Open Rivet plots in the browser
$ open rivet-plots/index.html



Generate Pythia Events:

make a new directory to keep pythia data
$ mkdir TEST-pythia
run with PbPb parameters (.params) file
Get Pythia running options
$ run-pythia —help

# run for 1000 events with a output file name (.hepmc)
$time run-pythia -e 7000 -o pythia8.pbpb2760.hepmc -c "SoftQCD:all on" -n 1000

In troubles with running Pythia
•	go to Sacrifice
•	$ cd src
•	$ emacs PythiaMain.cxx (comment the default options for beam energy and colliding energy) then give these parameters in .param file while running pythia
•	$ cd ..
•	$ make install
•	then run pythia again to generate event data
