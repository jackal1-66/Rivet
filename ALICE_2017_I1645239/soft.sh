#!/bin/bash
rivet --ignore-beams --pwd -a ALICE_2017_I1645239 SOFT106.5TeV.hepmc -o pp5TeV1e6new.yoda -n 1000000 >Rivetpp5TeV1e6new.log &
rivet --ignore-beams --pwd -a ALICE_2017_I1645239 ../ALICE_2017_I1511870/SOFT106.hepmc -o pp7TeV1e6new.yoda -n 1000000 >Rivetpp7TeV1e6new.log  &
