#!/bin/bash

alienv enter VO_ALICE@AliPhysics::vAN-20210223_ROOT6-1

AN="ALICE_2022_I1868463"
MCGen="P8Monash"

alien_find /alice/cern.ch/user/m/mgiacalo/Rivet/$AN/Simulations/$MCGen/ Rivet.yoda >Collection.xml

if [ -d "$PWD/Yodas" ]; then
    echo "Yoda folder exists"
    if [ -z "$(ls -A $PWD/Yodas)" ]; then #checks if folder is empty
        echo "Folder is empty"
    else
        echo "Deleting files"
        rm Yodas/*
    fi    
    echo "DONE"
else
    echo "Creating Yodas folder"
    mkdir Yodas
    echo "DONE"
fi

count=1

while IFS= read -r line
do
  alien_cp "$line" file:Yodas/Rivet_$count.yoda
  let count++
done < "Collection.xml"

exit

alienv enter VO_ALICE@AliGenerators::v20220226-1

export RIVET_ANALYSIS_PATH=$PWD/../
export RIVET_DATA_PATH=$PWD/../

rivet-merge -e Yodas/Rivet* -o Rivet.yoda

exit

