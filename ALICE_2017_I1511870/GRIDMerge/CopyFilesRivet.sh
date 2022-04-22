#!/bin/bash

#Execute inside AliPhysics environment

AN="ALICE_2017_I1511870"
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
