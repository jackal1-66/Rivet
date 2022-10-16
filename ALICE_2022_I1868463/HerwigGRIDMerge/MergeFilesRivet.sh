#!/bin/bash

#Execute inside AliGenerators environment

export RIVET_ANALYSIS_PATH=$PWD/../
export RIVET_DATA_PATH=$PWD/../

rivet-merge -e Yodas/Rivet* -o RivetHerwigLHCMB.yoda


