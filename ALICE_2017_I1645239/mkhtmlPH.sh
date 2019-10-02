#!/bin/bash
rivet-mkhtml --pwd --errs -o Pythia8Herwig7_1e6_$1 Pythia8_merge_050919.yoda:'Title=Pythia8 (Monash 2013)' pythia8mode0all.yoda:'Title=Pythia8 (CR mode $0$)' pythia8mode2all.yoda:'Title=Pythia8 (CR mode $2$)' Herwig7pp1e67TeV.yoda:'Title=Herwig7'
#Program to use rivet-mkhtml with Pythia8 and Herwig7
