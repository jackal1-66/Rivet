#!/bin/bash

#Start the script after opening aligenerators
WD=$PWD

cp LHC-MBDefault.in $HERWIG_ROOT/share/Herwig/.
cp LHC-MB_CRBaryonicRec.in $HERWIG_ROOT/share/Herwig/.
cp LHC-MB_CRPlain.in $HERWIG_ROOT/share/Herwig/.
cd $HERWIG_ROOT/share/Herwig
Herwig read LHC-MBDefault.in
Herwig read LHC-MB_CRBaryonicRec.in
Herwig read LHC-MB_CRPlain.in
Herwig run -N 1000000 LHC-MBDefault.run &>$WD/Herwig1e6SOFTDef.log &
Herwig run -N 1000000 LHC-MB_CRPlain.run &>$WD/Herwig1e6CRPlain.log &
Herwig run -N 1000000 LHC-MB_CRBaryonicRec.run &>$WD/Herwig1e6CRBaryonicRec.log &
cd $WD
#Start Rivet analysis
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/Herwig7.fifo -o herwig7pp1e6.yoda -n 1000000 &>RivetHerwig7pp1e6.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/Herwig7Bar.fifo -o herwig7pp1e6bar.yoda -n 1000000 &>RivetHerwig7pp1e6bar.log &
rivet --ignore-beams --pwd -a ALICE_2022_I1868463 /tmp/Herwig7Plain.fifo -o herwig7pp1e6plain.yoda -n 1000000 &>RivetHerwig7pp1e6plain.log &


