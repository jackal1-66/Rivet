#!/bin/bash

set -o errexit

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} -n \# -a AnalysisID [-a AnalysisID +] -g Generator -t Tune -s energy -p ModePar
EOF
}

# Pythia6 Perugia0: tune 320; Perugia2011: tune 350
# C   350 Perugia 2011 : Retune of Perugia 2010 incl 7-TeV data (Mar 2011)
# C   351 P2011 radHi : Variation with alphaS(pT/2) 
# C   352 P2011 radLo : Variation with alphaS(2pT)
# C   353 P2011 mpiHi : Variation with more semi-hard MPI
# C   354 P2011 noCR  : Variation without color reconnections
# C   355 P2011 LO**  : Perugia 2011 using MSTW LO** PDFs       (Mar 2011)
# C   356 P2011 C6    : Perugia 2011 using CTEQ6L1 PDFs         (Mar 2011)
# C   357 P2011 T16   : Variation with PARP(90)=0.32 away from 7 TeV
# C   358 P2011 T32   : Variation with PARP(90)=0.16 awat from 7 TeV
# C   359 P2011 TeV   : Perugia 2011 optimized for Tevatron     (Mar 2011)

# Pythia8 4C: 5; Monash2013: 14
#   Have a look to the param_Pythia8 to enable/disable processes
#     - Initial State Radiation
#     - Final State Radiation
#     - Multi-Parton Interaction
#     - Colour reconnection
#     - Parton distribution functions

NEV=2000

ExecutionMachine=`hostname`
echo "Execution machine : ${ExecutionMachine}"
if [[ ${ExecutionMachine} == "lxplus"* ]]
then
    FIFOPATH=/tmp/fifo_User${UID}_`hostname -s`.hepmc
    
else # grid worker node or local machine
    FIFOPATH=${PWD}/fifo_${ALIEN_PROC_ID:-local}.hepmc
fi

OUTPUTFILE=Rivet.yoda
GENTYPE="Pythia8"       # Pythia6
GENTUNE=14              # 354
SQRTS=7000
SQRTS2=3500
PAR=""

declare -a analyses
AIND=1
OPTIND=1

while getopts "n:a:g:t:s:p:" opt; do
    case "$opt" in
            n)
                    NEV=$OPTARG
                    ;;
            a)
                    analyses[$((AIND++))]=$OPTARG
                    ;;
            g)
                    GENTYPE=$OPTARG
                    ;;
            t)
                    GENTUNE=$OPTARG
                    ;;
            s)
                    SQRTS=$OPTARG
                    SQRTS2=$(($OPTARG / 2))
                    ;;
            p)      
                    PAR=$OPTARG
                    ;;
            \?)
                    echo "Invalid option -$OPTARG"
                    ;;
    esac
done

RIVETARG=""
for ii in `seq 1 $((AIND-1))`
do
    if [ -e "${analyses[ii]}.cc" ]; then
        rivet-build Rivet_${analyses[ii]}.so ${analyses[ii]}.cc
        echo "Run-Rivet [0.${ii}] - code plugin compiled, ok! (= ${analyses[ii]}.cc)"
    fi
    RIVETARG+=" -a ${analyses[ii]}"
    echo "Run-Rivet [0.${ii}] - code plugin added as argument, ok! (= ${analyses[ii]})"
done

set +o errexit



mkfifo ${FIFOPATH}

    if ( test -p ${FIFOPATH} )
    then
        echo "Run-Rivet [1.a] - FIFO set up, ok! (= ${FIFOPATH})"
    else    
        echo "Run-Rivet [1.a] - FIFO not set up... exit !"
        exit 1
    fi

#The following is taken from MCPLOTS "def" settings






#params file for Pythia8
cat << EOF > param_Pythia8.txt
#Beams
Beams:idA = 2212 ! Proton
Beams:idB = 2212

# Min. bias
#SoftQCD:all = on

# Min. bias alternative
SoftQCD:nonDiffractive = on
SoftQCD:singleDiffractive = on
SoftQCD:doubleDiffractive = on

# random seed
Random:setSeed = on
Random:seed = 0

# Set cuts
# Use this for hard leading-jets in a certain pT window
PhaseSpace:pTHatMin = 0   # min pT
PhaseSpace:pTHatMax = $SQRTS   # max pT

# Use this for hard leading-jets in a certain mHat window
PhaseSpace:mHatMin = 0   # min mHat
PhaseSpace:mHatMax = $SQRTS   # max mHat

# Makes particles with c*tau0 > 10 mm stable: (default value = 10.0 in mm / Here = 10 m)
# See http://home.thep.lu.se/~torbjorn/pythia81html/ParticleDecays.html
# tau0 = seems to deal with particle species by species, i.e. selection based on 'cTau(PDG)'
ParticleDecays:limitTau0 = On
ParticleDecays:tau0Max = 10000.0
# FIXME


# Set tune
Tune:preferLHAPDF=0 ! OK for internal tunes
Tune:ee=7 ! pp tune will change it if needed
Tune:pp=$GENTUNE

# Parton level
# PartonLevel:ISR = off  # uncomment to disable Initial State Radiation
# PartonLevel:FSR = off  # uncomment to disable Final State Radiation
# PartonLevel:MPI = off  # uncomment to disable Multi-Parton Interaction

# Colour reconnection
# ColourReconnection:reconnect = off  # uncomment both lines to switch off colour reconnection
# PartonLevel:earlyResDec = off       # uncomment both lines to switch off colour reconnection

# PDF tuned for Monash2013
# PDF:pSet = 13  # NNPDF2.3 QCD+QED LO   alpha_s(M_Z) = 0.130. (default)
# PDF:pSet = 14  # NNPDF2.3 QCD+QED LO   alpha_s(M_Z) = 0.119.
# PDF:pSet = 15  # NNPDF2.3 QCD+QED NLO  alpha_s(M_Z) = 0.119.
# PDF:pSet = 16  # NNPDF2.3 QCD+QED NNLO alpha_s(M_Z) = 0.119.
EOF

    if ( test -s param_Pythia8.txt )
    then
        echo "Run-Rivet [2.a] - Pythia8 config file, param_Pythia8.txt, set up, ok!"
    else    
        echo "Run-Rivet [2.a] - Pythia8 config file, param_Pythia8.txt, not set up... exit !"
        exit 1
    fi



#params file for Pythia6
cat << EOF > param_Pythia6.txt
# Minimum Bias
## Switch off all processes
MSEL 0
## Switch on elastic scattering
##MSUB(91) 1
## Switch on single-diffractive events
MSUB(92) 1
MSUB(93) 1
## Switch on double-diffractive events
MSUB(94) 1
## Switch on low-pT scattering
MSUB(95) 1

# Set cuts
# Use this for hard leading-jets in a certain pT window
# min pT
CKIN(3) 0
# max pT
CKIN(4) $SQRTS

# Use this for hard leading-jets in a certain mHat window
# min mHat
CKIN(1) 0
# max mHat
CKIN(2) $SQRTS

# Makes particles with c*tau > 10 mm stable: (default value = 10.0 in mm / Here = 10 m)
MSTJ(22)     2
PARJ(71)     10000.0
# FIXME

# Set tune
MSTP(5) $GENTUNE
EOF



    if ( test -s param_Pythia6.txt )
    then
        echo "Run-Rivet [2.b] - Pythia6 config file, param_Pythia6.txt, set up, ok!"
    else    
        echo "Run-Rivet [2.b] - Pythia6 config file, param_Pythia6.txt, not set up... exit !"
        exit 1
    fi



    
CRMClocation=`type crmc | awk -F " " '{print $3}'` # "crmc is /cvmfs/...."
echo "Run-Rivet [2.c] - EPOS-LHC (CRMC), i)  Locate where is CRMC : $CRMClocation"

PathToEPOSlibs=`echo $CRMClocation | sed -n 's/bin\/crmc//gp'`
echo "Run-Rivet [2.c] - EPOS-LHC (CRMC), ii) pin down the EPOS libs repo : $PathToEPOSlibs"
    # typically : 
    #         user machine : /home/<user>/AliceSuite/sw/ubuntu1804_x86-64/CRMC/v1.7.0-correctHepMC-1/
    #         lxplus, grid :  /cvmfs/alice.cern.ch/el6-x86_64/Packages/CRMC/v1.7.0-correctHepMC-6/

cat << EOF > param_CRMC1pt7pt0.txt
!!input file for crmc
!! a line starting with "!" is not read by the program

!switch fusion off      !nuclear effects due to high density (QGP) in EPOS
                        !more realistic but slow (can be switched off)

!set istmax 1           !include virtual mother particles with EPOS to identify particle source

!set isigma 2           !uncomment to get correct inelastic cross-section for heavy ions with EPOS, QGSJET and DPMJET

!!Set up particle Decays
!switch decay off       !no decay at all

nodecay  14    !uncomment not to decay mu- (PDG id =  13)
nodecay -14    !uncomment not to decay mu+ (PDG id = -13)                                                                                                                                     
nodecay  1120  !uncomment not to decay proton  (PDG id =  2212) (for pythia)                                                                                                                  
nodecay -1120  !uncomment not to decay aproton (PDG id = -2212) (for pythia)                                                                                                                  
nodecay  1220  !uncomment not to decay neutron  (PDG id =  2112)                                                                                                                              
nodecay -1220  !uncomment not to decay aneutron (PDG id = -2112)                                                                                                                              
nodecay  120   !uncomment not to decay pi+ (PDG id =  211)                                                                                                                                    
nodecay -120   !uncomment not to decay pi- (PDG id = -211)                                                                                                                                    
nodecay  130   !uncomment not to decay k+ (PDG id =  321)                                                                                                                                     
nodecay -130   !uncomment not to decay k- (PDG id = -321)                                                                                                                                     
nodecay -20    !uncomment not to decay k0L (PDG id = -130)                                                                                                                                    
nodecay  17    !uncomment not to decay deuterium                                                                                                                                              
nodecay -17    !uncomment not to decay antideuterium                                                                                                                                          
nodecay  18    !uncomment not to decay tritium                                                                                                                                                
nodecay -18    !uncomment not to decay antitritium                                                                                                                                            
nodecay  19    !uncomment not to decay alpha                                                                                                                                                  
nodecay -19    !uncomment not to decay antialpha                                                                                                                                              
!... more possible (with EPOS id (not PDG))                                                                                                                                                   
!for other particles, please ask authors ... or use minimum ctau (cm) :                                                                                                                       
                                                                                                                                                                                              
MinDecayLength  1000.    !minimum c.Tau to define stable particles (cm)   !default = 1. cm                                                                                                                       
                                                                                                                                                                                              
fdpmjet path    ${PathToEPOSlibs}/tabs/
fqgsjet dat     ${PathToEPOSlibs}/tabs/qgsjet.dat
fqgsjet ncs     ${PathToEPOSlibs}/tabs/qgsjet.ncs
fqgsjetII03 dat ${PathToEPOSlibs}/tabs/qgsdat-II-03.lzma
fqgsjetII03 ncs ${PathToEPOSlibs}/tabs/sectnu-II-03
fqgsjetII dat   ${PathToEPOSlibs}/tabs/qgsdat-II-04.lzma
fqgsjetII ncs   ${PathToEPOSlibs}/tabs/sectnu-II-04
fname check  none
fname initl     ${PathToEPOSlibs}/tabs/epos.initl
fname iniev     ${PathToEPOSlibs}/tabs/epos.iniev
fname inirj     ${PathToEPOSlibs}/tabs/epos.inirj
fname inics     ${PathToEPOSlibs}/tabs/epos.inics
fname inihy     ${PathToEPOSlibs}/tabs/epos.inihy



set pytune 350   !possibility to change PYTHIA tune (for PYTHIA only !)

!!ImpactParameter
!set bminim 0 !works with epos
!set bmaxim 4

!!Debug Output
!print * 4
!printcheck screen

EndEposInput
EOF

# Change name for the config file to have the default name
mv param_CRMC1pt7pt0.txt crmc.param



    if ( test -s crmc.param )
    then
        echo "Run-Rivet [2.c] - EPOS-LHC (CRMC), iii) config file, crmc.param, set up, ok!"
    else    
        echo "Run-Rivet [2.c] - EPOS-LHC (CRMC), iii) config file, crmc.param, not set up... exit !"
        exit 1
    fi







#params file for Sherpa
# https://sherpa.hepforge.org/doc/SHERPA-MC-2.1.1.html
#
# FIXME check cTau is set to 10 m !!!
#
cat << EOF > param_Sherpa2.txt
# steering file based on example from Sherpa 1.2.3 distribution:
#   share/SHERPA-MC/Examples/Tevatron_UE/Run.dat

(run){
  # disable colorizing of text printed on screen:
  PRETTY_PRINT = Off
  # Output=3 will display information, events and errors
  OUTPUT=3
    
  # set random seed:
  # (see section "6.1.3 RANDOM_SEED" of Sherpa manual for details)
  RANDOM_SEED = 1 1 1 1
  
  # Event output file:
  EVENT_OUTPUT = HepMC_Short[${FIFOPATH}]
  # full name of output file will be:
  #  "[${FIFOPATH}].hepmc2g"

  
  # disable splitting of HepMC output file:
  FILE_SIZE = 1000000000
  
  # Makes particles with c*tau > 10 mm stable: 10.0 = default value (in mm)
  # MAX_PROPER_LIFETIME = 10000.0   
  # FIXME
  
  # Default tune, CT10/ Alternative : CT10_UEup, CT10_UEdown
  TUNE = $GENTUNE
  EVENT_TYPE = MinimumBias
  SOFT_COLLISIONS = Shrimps
  # elastic, single- and double-diffractive + inelastic in due proportions
  Shrimps_Mode = All
}(run)

(beam){
  BEAM_1 =  2212; BEAM_ENERGY_1 = $SQRTS2;
  BEAM_2 =  2212; BEAM_ENERGY_2 = $SQRTS2;
}(beam)

(processes){
  Process 93 93 -> 93 93
  Order_EW 0
  # parton parton -> parton parton  
  # Fixing the order of electroweak couplings to ‘0’, 
  # matrix elements of all partonic subprocesses for Drell-Yan production without any 
  # and with up to 0 extra QCD parton emissions will be generated.
  End process
}(processes)

(selector){
  # To be as inclusive as possible, the pT cut has been lowered to the
  # same value as in the multiple parton interactions.
  # Note that this pT cut has to be adjusted if E_CMS is changed,
  # such that it is never lower then
  #   pT_min = SCALE_MIN*(E_CMS/1800)^RESCALE_EXPONENT
  # in the multiple parton interactions.
  # Parameters of tuned MPI cut-off for cteq66 (the default PDF):
  #   SCALE_MIN = 2.63
  #   RESCALE_EXPONENT = 0.192
  NJetFinder  2  2.63*pow(E_CMS/1800,0.192)  0.0  1.0

  # Use this for hard leading jets in a certain mass window
  Mass 93 93 0 $SQRTS
}(selector)

(me){
  ME_SIGNAL_GENERATOR = Comix
}(me)

(mi){
  MI_HANDLER = Amisic
}(mi)

EOF


    if ( test -s param_Sherpa2.txt )
    then
        echo "Run-Rivet [2.d] - Sherpa config file, param_Sherpa2.txt, set up, ok!"
    else    
        echo "Run-Rivet [2.d] - Sherpa config file, param_Sherpa2.txt, not set up... exit !"
        exit 1
    fi



#params file for Herwig7.1.2, LHC minimum bias
# Taken from $HERWIG_ROOT/share/Herwig/LHC-MB.in
# https://herwig.hepforge.org/tutorials/
#
# FIXME cTau to be set to 10 m !!!
#
cat << EOF > param_Herwig-LHC-MB-WithBaryonReconnection.in
# -*- ThePEG-repository -*- taken from src/LHC-MB.in, with BaryonicReconnection.in activated, Patrick Kirchgaesser

################################################################################
# This file contains our best tune to UE data from ATLAS at 7 TeV. More recent
# tunes and tunes for other centre-of-mass energies as well as more usage
# instructions can be obtained from this Herwig wiki page:
# http://projects.hepforge.org/herwig/trac/wiki/MB_UE_tunes
# The model for soft interactions and diffractions is explained in
# [S. Gieseke, P. Kirchgaesser, F. Loshaj, arXiv:1612.04701]
################################################################################

read snippets/PPCollider.in

##################################################
# Technical parameters for this run
##################################################
cd /Herwig/Generators
##################################################
# LHC physics parameters (override defaults here) 
##################################################
set EventGenerator:EventHandler:LuminosityFunction:Energy ${SQRTS}.0


# Minimum Bias
read snippets/MB.in

# Read in parameters of the soft model recommended for MB/UE simulations
read snippets/SoftTune.in

# Diffraction model
read snippets/Diffraction.in

# Read in snippet in order to use baryonic reconnection model with modified gluon splitting (uds)
# For more details see [S. Gieseke, P. KirchgaeÃŸer, S. PlÃ¤tzer. arXiv:1710.10906]]
##############################################################################################

read snippets/BaryonicReconnection.in


##################################################
# Analyses
##################################################


# cd /Herwig/Analysis
# create ThePEG::RivetAnalysis RivetAnalysis RivetAnalysis.so

# cd /Herwig/Generators
# insert EventGenerator:AnalysisHandlers 0 /Herwig/Analysis/RivetAnalysis

# insert /Herwig/Analysis/RivetAnalysis:Analyses 0 ATLAS_20XX_XXXXXXX


#set /Herwig/Analysis/Plot:EventNumber 54
#cd /Herwig/Generators
#insert EventGenerator:AnalysisHandlers 0 /Herwig/Analysis/Plot

# read /Herwig/snippets/HepMC.in
create ThePEG::HepMCFile /Herwig/Analysis/HepMC HepMCAnalysis.so
set /Herwig/Analysis/HepMC:PrintEvent $NEV
set /Herwig/Analysis/HepMC:Format GenEvent
set /Herwig/Analysis/HepMC:Units GeV_mm
set /Herwig/Analysis/HepMC:Filename ${FIFOPATH}
insert /Herwig/Generators/EventGenerator:AnalysisHandlers 0 /Herwig/Analysis/HepMC


##################################################
# Save run for later usage with 'Herwig run'
##################################################
cd /Herwig/Generators
saverun param_Herwig-LHC-MB-WithBaryonReconnection EventGenerator
EOF




    if ( test -s param_Herwig-LHC-MB-WithBaryonReconnection.in )
    then
        echo "Run-Rivet [2.e] - Herwig config file, param_Herwig-LHC-MB-WithBaryonReconnection.in, set up, ok!"
    else    
        echo "Run-Rivet [2.e] - Herwig config file, param_Herwig-LHC-MB-WithBaryonReconnection.in, not set up... exit !"
        exit 1
    fi





case "$GENTYPE" in
Pythia6)
	echo "Run-Rivet [3.a] - Running Pythia 6 simulation tune $GENTUNE with sqrts = $SQRTS GeV, $NEV events"
	agile-runmc Pythia6:HEAD -P param_Pythia6.txt -n${NEV} --out=${FIFOPATH} --beams=LHC:$SQRTS --randomize-seed &
	;;
Pythia8)
	echo "Run-Rivet [3.a] - Running Pythia 8 simulation tune $GENTUNE with sqrts = $SQRTS GeV, $NEV events"
    if [ "$PAR" = "mode0.par" ] || [ "$PAR" = "mode2.par" ]; then
        run-pythia -c "SoftQCD:all on" -i $PAR -e $SQRTS -n $NEV -o ${FIFOPATH} &
    else
        echo "Running with default Monash 2013 tune"    
	    run-pythia -i param_Pythia8.txt -e $SQRTS -n $NEV -o ${FIFOPATH} &
    fi    
	;;
EPOSlhc)
	echo "Run-Rivet [3.a] - Running EPOS-LHC simulation with sqrts = $SQRTS GeV, $NEV events"
	# cp $CRMC_ROOT/crmc.param .
	crmc -n${NEV} -m0 -p$SQRTS2 -P-$SQRTS2  -i1 -I1  -f ${FIFOPATH} &
	;;
EPOSv3)
	echo "Run-Rivet [3.a] - Running EPOSv3 simulation with sqrts = $SQRTS GeV, $NEV events... TBD"
	;;	
SHERPA)
        echo "Run-Rivet [3.a] - Running SHERPA simulation tune $GENTUNE with sqrts = $SQRTS GeV, $NEV events"
  
        export seed1=$[ ( $RANDOM % 31328 ) ] 
        export seed2=$[ ( $RANDOM % 30381 ) ]
        export seed3=$[ ( $RANDOM % 30381 ) ] 
        export seed4=$[ ( $RANDOM % 30381 ) ] 
        echo "Sherpa - random seeds : seed1 = ${seed1} / seed2 = ${seed2} / seed3 = ${seed3} / seed4 = ${seed4} / "
        # NOTE 1 :
        # The two independent integer-valued seeds are specified by the option "RANDOM_SEED=A B". 
        # The seeds A and B may range from 0 to 31328 and from 0 to 30081, respectively
            
        SHERPA_INCLUDE_PATH=$SHERPA_ROOT/include/SHERPA-MC
        SHERPA_SHARE_PATH=$SHERPA_ROOT/share/SHERPA-MC
        SHERPA_LIBRARY_PATH=$SHERPA_ROOT/lib/SHERPA-MC
        LD_LIBRARY_PATH=$SHERPA_LIBRARY_PATH:$LD_LIBRARY_PATH 
    
    
        # NOTE 2 : 
        #   Sherpa produce the directories Process/ Results/ and MIG_P+P+_7000_ct10_1/
        #       = result of the integration of cross-sections
        #   If one want to store those files into another dir like ./Sherpa-RunningDir/, 
        
        Sherpa -f param_Sherpa2.txt -e $NEV  EVENT_OUTPUT=HepMC_Short[${FIFOPATH}] RANDOM_SEED=${seed1} ${seed2} ${seed3} ${seed4} &
        ;;
HERWIG)
        echo "Running HERWIG++ simulation with sqrts = $SQRTS, $NEV events..."
        # NOTE : no need of runThePEG ?
        
        # All analysis details are set up in 'param_Herwig-LHC-MB-WithBaryonReconnection.in' to be initialised...
        Herwig --repo=${HERWIG_ROOT}/share/Herwig read param_Herwig-LHC-MB-WithBaryonReconnection.in
        # ... then events can be generated
        Herwig --repo=${HERWIG_ROOT}/share/Herwig run param_Herwig-LHC-MB-WithBaryonReconnection.run --numevents=$NEV --seed=$RANDOM &
        ;;        

esac

    echo "Run-Rivet [3.b] - MC generator now launched"




export RIVET_ANALYSIS_PATH=$PWD
#rivet --pwd $RIVETARG:spdabseta=0.6:spdminpt=30. -H ${OUTPUTFILE} ${FIFOPATH} #run first for calibration, this is symmetric SPD acceptance

#Asymmetric SPD acceptance
#rivet --pwd $RIVETARG:spdetamin=-0.6:spdetamax=0.8:spdminpt=30. -H ${OUTPUTFILE} ${FIFOPATH}

#rivet --pwd -p calibration.yoda $RIVETARG:cent=GEN -H ${OUTPUTFILE} ${FIFOPATH} #run secondly for analysis vs multiplicity
rivet --pwd $RIVETARG -H ${OUTPUTFILE} ${FIFOPATH} #run this instead for analysis without calibration needed (DEFAULT option)
    echo "Run-Rivet [3.c] - Rivet now launched"






echo "****************************************************************"
echo "Working directory status (before removal of temporary setup files)"
ls -lh

rm ${FIFOPATH}
rm param_Pythia6.txt
rm param_Pythia8.txt
rm crmc.param
rm param_Sherpa2.txt
rm param_Herwig-LHC-MB-WithBaryonReconnection.in



if [ -s ${OUTPUTFILE} ]; then
	echo -e "\n*****************************************************************"
	echo    "CHECK 1 - Examining Nb of Generated Events "
	
	# We are looking for the part of the YODA file that looks like :
    #     BEGIN YODA_COUNTER_V2 /_EVTCOUNT
    #     Path: /_EVTCOUNT
    #     Title: 
    #     Type: Counter
    #     ---
    #     # sumW   sumW2   numEntries
    #     1.000000e+03    1.000000e+03    1.000000e+03
    #     END YODA_COUNTER_V2

    
    # let counter=0
    # counter=`expr $counter + 1`

    NbYodaCounters=`gawk 'BEGIN{ RS=""; FS="\n" }  /BEGIN YODA_COUNTER/,/END YODA_COUNTER/ {printf "%s \n --- Block %d\n", $0,i  >"YodaCounter-Block-"++i".log"}  END{print i}' ${OUTPUTFILE}`
    echo "Number of YODA_COUNTER blocks found in yoda file : $NbYodaCounters"
        
        # NOTE : 
        # - make the record separator empty to have a line over line reading 
        # - make the field separator newline so that the fields counts are entire lines
        # the point is to isolate the full block between markups BEGIN and END in the yoda file + store each block within a .log file
    
    
    if [ $NbYodaCounters -eq 0 ]
    then
            echo "WARNING: Nb of YODA_COUNTER = 0 ! Weird... removing Yoda output... exit !"
            rm ${OUTPUTFILE}
            # No need to remove YodaCounter-Block-$iCounter.log; in such a case, there should be none.
            exit 3
    else
        echo -e "(a priori, 2 per yoda file... _EVTCOUNT + /RAW/_EVTCOUNT) \n"
           
        for iCounter in `seq 1 $NbYodaCounters`    
        do       
            read SumOfWeights SumOfWeights2 numEntries NbEntriesEqualToNGenAsked <<< $( egrep -A2 'numEntries' YodaCounter-Block-$iCounter.log | tail -n 2 | head -n 1 | awk -v N=${NEV} '{printf "%d %d %d %d", $1,$2,$3, ($3/N < 0.999)? 0:1}' )
            echo "   - YODA_COUNTER[${iCounter}] : numEntries = $numEntries / Sum of Weights = $SumOfWeights / Sum of (Weights)² = $SumOfWeights2 -> NbEntriesEqualToNGenAsked = $NbEntriesEqualToNGenAsked"
            
                echo "   - YODA_COUNTER[${iCounter}] : numEntries to be compared with the Nb of evts asked initially : ${NEV}"
                
                
            if [ ${NbEntriesEqualToNGenAsked} -eq 0 ]
            then
                echo "   - YODA_COUNTER[${iCounter}] : WARNING ! Nb of Evt counts below the 99.9% threshold, removing Yoda output... exit !"
                rm ${OUTPUTFILE}
                exit 2
            else
                echo "  -> YODA_COUNTER[${iCounter}] : Check done ! NumEvtEntries within 99.9% of the initial statistics asked for generation"
                echo " "
                rm YodaCounter-Block-$iCounter.log
            fi
        done
    fi # NbYodaCounters ≠ 0
fi # yoda output file exists


echo -e "\n*****************************************************************"
echo    "CHECK 2 - Running rivet-cmphistos for general validation of the output"
rivet-cmphistos --pwd ${OUTPUTFILE}
if [ $? -ne 0 ]; then
	echo ""
	echo "WARNING: YODA output not valid, removing Yoda output"
	rm ${OUTPUTFILE}
fi

exit 0

