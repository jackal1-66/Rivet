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


# Generate Pythia Events:

make a new directory to keep pythia data
$ mkdir TEST-pythia
run with PbPb parameters (.params) file
Get Pythia running options
$ run-pythia —help

# Run for 1000 events with a output file name (.hepmc)
$time run-pythia -e 7000 -o pythia8.pbpb2760.hepmc -c "SoftQCD:all on" -n 1000

#Pythia Tunes definition with Sacrifice (1e6 events with fifo)

$mkfifo test.fifo
**Monash**
$run-pythia -n 1000000 -o test.fifo -e 13000 -c "SoftQCD:all on" >Pythiapp1e6.log &
**Mode0**
$run-pythia -n 1000000 -o test.fifo -e 13000 -c "SoftQCD:all on" -i mode0.par >Pythiapp1e6mode0.log &
**Mode2**
$run-pythia -n 1000000 -o test.fifo -e 13000 -c "SoftQCD:all on" -i mode2.par >Pythiapp1e6mode2.log &

$rivet --ignore-beams --pwd -a ALICE_2017_I1511870 test.fifo -o pythia8pp1e6new.yoda -n 1000000 >RivetPythia8pp1e6new.log &
(mode0.par and mode2.par are inside the main folder of the repo)
You can also add a seed to the sacrifice application by adding the parameter -r

In troubles with running Pythia
•	go to Sacrifice
•	$ cd src
•	$ emacs PythiaMain.cxx (comment the default options for beam energy and colliding energy) then give these parameters in .param file while running pythia
•	$ cd ..
•	$ make install
•	then run pythia again to generate event data

# Run HERWIG on the server (OBSOLETE)
The installation on the server was not so easy and it is a little "crooked", so in order to run HERWIG using fifos and rivet there are precise steps to follow:

1) Type "scldev" which will enable the correct versions of g++ compiler and python
2) Type "activate" which will enable the Herwig interface
3) If the .in file was not read, type "Herwig read <filename.in>" which will generate a .run file
4) Run the Herwig file using "Herwig run <filename.run> -N <number_of_events_to_generate>" & 
5) Run the rivet program using the fifo generated by Herwig. This will return an error since the rivet environment was not defined (yet) [THIS STEP IS MANDATORY IN ORDER TO RUN THE SIMULATION, OTHERWISE HERWIG WILL RETURN AN INTERPRETER ERROR]
6) Type "rivetenv" which will enable rivet environment
7) Run again rivet
8) Wait for the events to be generated

# Merging more analysis

Before merging, the RIVET_ANALYSIS_PATH and RIVET_DATA_PATH must be set accordingly so that they contain the path of the analysis you're working on. 
In order to do that you should use the function rivet-merge (from Rivet 2.7.2). This allowed me to merge multiple yoda files including weights just by doing "rivet-merge file1.yoda file2.yoda file3.yoda -o filemerged.yoda", without -e option which complicate things related to weights (this was instead used in order to merge multiple jobs of the same analysis).
The normal rivet-merge is useful for example to merge different simulations like pp and pPb.

# Use Dummy Histos on Rivet

It is possible to create dummy histograms which are linked (referencing data) from experimental histograms. This is done using the command:

Histo1DPtr   \_h\_0000, \_h\_0001; // for a histogram
\_h\_0000 = BookHisto1D("d01-x01-y01");
\_h\_0001 = BookHisto1D("TMP/test", refData(1,1,1));

This will lead to the histo _h_0001 being set (binning, etc) as the experimental histogram d01-x01-y01.

# Edit Legend to rivet plots

In order to do so you can edit the titles in this way

$rivet-mkhtml --pwd --errs rivet.yoda:'Title=This is my custom Title' rivet2.yoda:'Title=This is my other custom title'

# Run HERWIG with AliGenerators

Unfortunately the installation of AliGenerators doesn't work that good, so in order to make it work you should copy your configuration .in files
into the folder $HERWIG_ROOT/share/Herwig/, cd into the folder and then finally use Herwig read as usual. 
For some reasons that I don't understand the file SoftTune.in was removed from the snippets folder, so you can create it beforehand by copying the one 
you can find in the main folder of this repository.

# Running on the GRID

Running multiple events on a server it's extremely time consuming, but doing it on the GRID can reduce that time drastically. 
Let's start from the beginning. You need a certificate provided by the CERN certification authority https://ca.cern.ch/ca/. 
When you have it drag and drop it on your browser, you're going to need it later. 
Now we have to modify the certificate downloaded in order to extract the certificate and private key you're going to use to access the GRID. 
So from terminal do:
1) to extract certificate

$openssl pkcs12 -in myCert.p12 -clcerts -nokeys -out $HOME/.globus/usercert.pem 

2) to extract the private key

$openssl pkcs12 -in myCert.p12 -nocerts -out $HOME/.globus/userkey.pem

3) Set the mode on both of them in order that only the owner can read/write them: 

$chmod 600 $HOME/.globus/userkey.pem
$chmod 600 $HOME/.globus/usercert.pem

Done. Now you should be able to access ALIen, which is the interface for the GRID system on ALICE. 
To do so load the AliPhysics environment: 
$alienv enter AliPhysics
and try $alien.py, if things are setup correctly, you should be asked the password and will be able to enter the ALICE systems. 
Inserting files inside the GRID is unfortunately painful, so try to keep them as a bare minimum. 
To run RIVET on the GRID you need all the ALICE_YEAR_I\<InspireID\>.* files, the .jdl and .sh files you find in the main folder 
of the repo and also the parameter files mode0 and mode2. To put them on the GRID first enter with alien.py, 
cd into the folder you want to use and copy the path. Then copy your files inside alien from your pc by doing: 
$alien_cp file:filenametocopy *PATH_IN_ALIEN*/filenametocopy
for each file. 
After you've done this you can finally submit your rivetization on the GRID, but remember to edit the JDL file by inserting your 
analysis name and the files you need to upload (generally all the ALICE*.* and the mode*.par files). 
In the end try to run the analysis by doing a submit of the JDL inside the GRID, following the example for Monash you see in the jdl file. 
You can check the status of your jobs going to the alimonitor.cern.ch interface (MonALISA). 
When all the jobs are completed you can move to copy and merge in this order the results inside your PC using the macros you have in the GRIDMerge folder by changing accordingly both of them with respect to your analysis. 