#!/bin/bash

#  Antonin Maire, antonin.maire@cern.ch, Feb 2017


#  NOTE : 
#  I. - 
#       To be launched from a regular bash, i.e. not under alien
#  Full path under AliEn should look like :
#     /alice/cern.ch/user/a/amaire/Atelier-Rivet/ALICE-dNchdeta-pp5TeV/EPOSlhc-output/001/Rivet.yoda
#  and you want to store locally sthg like :
#     Rivet_EPOSlhc_001.yoda
# =============================================
#   alienPath:  path towards _AliEn_ where the files to be merged are located


# II. - 
#  Rivet-merge + combine the plots from data + multiple MC gen

# NOTE :
#  The user needs to have :
#   - an ongoing alien-token available on the machine
#   - the rivet environment sourced e.g. "alienv load Rivet/latest"



#  TODO : User change

EPOStune="EPOSlhc"
Pythia6tune="Pythia6-P2011"
Pythia8tune="Pythia8-Monash2013"

export PrefixPathName="/alice/cern.ch/user/a/amaire/Atelier-Rivet"
export alienDir="ALICE-dNchdeta-pp5TeV"


export analysisID="ALICE_2017_I9999999"

export NbSubjobs="250"
export NbEvtsPerSubjob="100000"


export TLaTeXInfo='$h^{\pm}$, pp 5.02 TeV'

 plotname[0]="d01-x01-y001"
 plotname[1]="d01-x01-y101"
 plotname[2]="d01-x01-y201" 
 plotname[3]="d01-x01-y010"
 plotname[4]="d01-x01-y011"
 plotname[5]="d01-x01-y012"
 plotname[6]="d01-x01-y013"
 plotname[7]="d01-x01-y014"
 plotname[8]="d01-x01-y015"
 plotname[9]="d02-x01-y001"
plotname[10]="d02-x01-y101"
plotname[11]="d02-x01-y020"
plotname[12]="d02-x01-y021"
plotname[13]="d02-x01-y022"
plotname[14]="d02-x01-y023"
plotname[15]="d02-x01-y024"
plotname[16]="d02-x01-y025"
plotname[17]="d02-x01-y026"
plotname[18]="d02-x01-y027"
plotname[19]="d02-x01-y030"
plotname[20]="d02-x01-y031"
plotname[21]="d02-x01-y032"
plotname[22]="d02-x01-y033"
plotname[23]="d01-x01-y110"
plotname[24]="d01-x01-y111"
plotname[25]="d01-x01-y112"
plotname[26]="d01-x01-y113"
plotname[27]="d01-x01-y114"
plotname[28]="d01-x01-y115"
plotname[29]="d01-x01-y210"
plotname[31]="d01-x01-y211"
plotname[32]="d01-x01-y212"
plotname[33]="d01-x01-y213"
plotname[34]="d01-x01-y214"
plotname[35]="d01-x01-y215"
plotname[36]="d01-x01-y220"
plotname[37]="d01-x01-y221"
plotname[38]="d01-x01-y222"
plotname[39]="d01-x01-y223"
plotname[40]="d01-x01-y224"
plotname[41]="d01-x01-y225"
plotname[42]="d01-x01-y226"
plotname[43]="d01-x01-y227"
plotname[44]="d02-x01-y120"
plotname[45]="d02-x01-y121"
plotname[46]="d02-x01-y122"
plotname[47]="d02-x01-y123"
plotname[48]="d02-x01-y124"
plotname[49]="d02-x01-y125"
plotname[50]="d02-x01-y126"
plotname[51]="d02-x01-y127"
plotname[52]="d02-x01-y130"
plotname[53]="d02-x01-y131"
plotname[54]="d02-x01-y132"
plotname[55]="d02-x01-y133"
plotname[56]="d02-x01-y220"
plotname[57]="d02-x01-y221"
plotname[58]="d02-x01-y222"
plotname[59]="d02-x01-y223"
plotname[60]="d02-x01-y224"
plotname[61]="d02-x01-y225"
plotname[62]="d02-x01-y226"
plotname[63]="d02-x01-y227"
plotname[64]="d02-x01-y230"
plotname[65]="d02-x01-y231"
plotname[66]="d02-x01-y232"
plotname[67]="d02-x01-y233" 




#  Below, the nothing to be changed directly by the user, a priori

# Sthg like : /alice/cern.ch/user/a/amaire/Atelier-Rivet/ALICE-dNchdeta-pp5TeV/EPOSlhc-output
#   = Where your YODA output of your subjobs is, under *AliEn*
alienPath[0]="${PrefixPathName}/${alienDir}/${Pythia8tune}-output"
alienPath[1]="${PrefixPathName}/${alienDir}/${Pythia6tune}-output"
alienPath[2]="${PrefixPathName}/${alienDir}/${EPOStune}-output"
#
# filename: prefixes of the files to be copied (if of several types)
#
filename[0]="Rivet"
#
# =======================================================


echo "I. - Copy and rivet-merge Grid output"


for iAlienPath in ${alienPath[@]}
do

    echo " "
    echo "------------------------------------------------------------ AliEn : ${iAlienPath}"
    echo " "
    
    grepCmd="(${EPOStune})|(${Pythia6tune})|(${Pythia8tune})"

    iMCgen=`echo ${iAlienPath} | grep -E -o "${grepCmd}"`
    if [[ -d "${iMCgen}-GridOutput" ]]
    then 
        echo "   A. - Dir ${iMCgen}-GridOutput, already existing... nothing to create"
    else
        if(mkdir ${iMCgen}-GridOutput)
        then
            echo "   A.1 - Dir ${iMCgen}-GridOutput, created"
        else
            echo "   A.1 - Pb with creating Dir ${iMCgen}-GridOutput ! ... exit"
            exit -1
        fi
    fi
    
    cd ${iMCgen}-GridOutput
    
    echo "   A.2 - Copy analysis code  ${PrefixPathName}/${alienDir}/${analysisID}.cc "
    alien_cp alien:${PrefixPathName}/${alienDir}/${analysisID}.cc   file:${analysisID}.cc
    
    
    echo "   B. - Change dir : `hostname` in `pwd`"
    echo " "
    
    for iRivetFile in ${filename[@]}
    do

        for iDir in `alien_ls ${iAlienPath}` # sthg like iDir = 001, 002, etc
        do

            outputFile="${iRivetFile}_${iMCgen}_${iDir}"
            if (! test -s "${outputFile}.yoda"   );          then    alien_cp alien:${iAlienPath}/${iDir}/${iRivetFile}.yoda file:${outputFile}.yoda         ; fi
            if (! test -s "log_archive_${outputFile}.zip" ); then    alien_cp alien:${iAlienPath}/${iDir}/log_archive.zip file:log_archive_${outputFile}.zip ; fi
            
        done # loop iDir Rivet subjobs

    done # loop iRivetFile
      
        
    echo "   C. - Check nb of files ..."
    
    export NbYodaFiles=`ls -1 ${iRivetFile}_${iMCgen}*yoda | wc -l`
    export NbLogArchives=`ls -1 log_archive_${iRivetFile}_${iMCgen}* | wc -l`
    
    
    if [[ ${NbYodaFiles}   -ne ${NbSubjobs} ]]; then echo "Pb in downloading the        yoda(${iMCgen}) files, only have (${NbYodaFiles}/${NbSubjobs}) ...   exit ! "; exit -1; fi
    if [[ ${NbLogArchives} -ne ${NbSubjobs} ]]; then echo "Pb in downloading the log_archive(${iMCgen}) files, only have (${NbLogArchives}/${NbSubjobs}) ... exit ! "; exit -1; fi
    echo "      Nb of Yoda files + log_archives : all ok, i.e. = ${NbSubjobs} each !"
    
    echo "   D. - Rivet-merge files ..."
    
    YodaOutputFile="z${iMCgen}-${NbSubjobs}jobs-x-${NbEvtsPerSubjob}evts.yoda"
    # yodamerge -o ${YodaOutputFile} Rivet_${iMCgen}_*.yoda # Deprecated command
    rivet-merge --output-file=${YodaOutputFile} Rivet_${iMCgen}_*.yoda
    
    if (test -s ${YodaOutputFile})
    then
        echo "   Rivet-merging for ${YodaOutputFile}, done !"
        cp -i ${YodaOutputFile} ..
    else
        echo "   Pb with rivet-merging ${YodaOutputFile}... exit !"
        exit -1    
    fi  
    
    
    echo "   E. - Roll back to native dir ..."
    cd -

done # loop iAlienPath




echo " "
echo "------------------------------------------------------------"
echo "   II. - Prepare combined yoda histos ..."
echo " "

ls -lh

echo " "
echo "  A. Linking towards .plot and data.yoda"

ln -s ../${analysisID}.plot
ln -s ../${analysisID}.yoda



echo " "
echo "  B. Creating merged plots"


# NOTE :
# In regular command line, the option of each yoda files should be given within quote :
#  vts.yoda:'Title=EPOS-LHC':'SmoothLine=1' 
# Here since we build the command line, + bash expansion, interpretation, singla quotes to be omitted
# See https://rivet.hepforge.org/make-plots.html



export ColorLineGray="LineColor={[rgb]{0.33,0.33,0.33}}"
export ColorBandGray="LineColor={[rgb]{0.33,0.33,0.33}}:ErrorBands=1:ErrorBandColor={[rgb]{0.80,0.80,0.80}}"


export ColorLineViolet="LineColor={[rgb]{0.60,0.19,0.80}}"
export ColorBandViolet="LineColor={[rgb]{0.60,0.19,0.80}}:ErrorBands=1:ErrorBandColor={[rgb]{0.87,0.63,0.87}}"

export ColorLineBlue="LineColor={[rgb]{0.0,0.33,0.79}}"
export ColorBandBlue="LineColor={[rgb]{0.0,0.33,0.79}}:ErrorBands=1:ErrorBandColor={[rgb]{0.50,0.82,1.0}}"

export ColorLineRed="LineColor={[rgb]{1.0,0.0,0.}}"
export ColorBandRed="LineColor={[rgb]{1.0,0.0,0.}}:ErrorBands=1:ErrorBandColor={[rgb]{1,0.71,0.75}}"

export ColorLineGreen="LineColor={[rgb]{0.19,0.60,0.19}}"
export ColorBandGreen="LineColor={[rgb]{0.19,0.60,0.19}}:ErrorBands=1:ErrorBandColor={[rgb]{0.56,0.93,0.56}}"

export ColorLineOrange="LineColor={[rgb]{1,0.54,0}}"
export ColorBandOrange="LineColor={[rgb]{1,0.54,0}}:ErrorBands=1:ErrorBandColor={[rgb]{1,0.94,0.80}}"

export ColorLineYellow="LineColor={[rgb]{1,0.84,0}}"
export ColorBandYellow="LineColor={[rgb]{1,0.84,0}}:ErrorBands=1:ErrorBandColor={[rgb]{1,0.98,0.75}}"


export Yoda_Data="${analysisID}.yoda:${ColorBandGray}"

export Yoda_EPOSlhc="${EPOStune}-${NbSubjobs}jobs-x-${NbEvtsPerSubjob}evts.yoda:${ColorBandRed}"  
export Yoda_Pythia6="${Pythia6tune}-${NbSubjobs}jobs-x-${NbEvtsPerSubjob}evts.yoda:${ColorBandGreen}"
export Yoda_Pythia8="${Pythia8tune}-${NbSubjobs}jobs-x-${NbEvtsPerSubjob}evts.yoda:${ColorBandBlue}"


echo "    Rivet-cmphistos / Yoda_Data     = ${Yoda_Data}"
echo "    Rivet-cmphistos / Yoda_EPOSlhc  = ${Yoda_EPOSlhc}"
echo "    Rivet-cmphistos / Yoda_Pythia6  = ${Yoda_Pythia6}"
echo "    Rivet-cmphistos / Yoda_Pythia8  = ${Yoda_Pythia8}"



echo " B.1 - Call rivet-cmphistos"

rivet-cmphistos --mc-errs \
    ${Yoda_Data}:'Title=ALICE data' \
    ${Yoda_EPOSlhc}:'Title=EPOS-LHC (CRMC 1.5.4)' \
    ${Yoda_Pythia6}:'Title=Pythia 6.428 - Perugia2011' \
    ${Yoda_Pythia8}:'Title=Pythia 8.230 - Monash2013'
#  NB the 1st yoda plot mentioned will be taken as the ref
#  The command will prodcuce sthg like "ALICE_2017_I9999999_d01-x01-y01.dat" file


echo " B.2 - Producing .pdf, .eps, .png"

for iPlot in ${plotname[@]} # e.g. "d01-x01-y01"
do

    echo " B.2.${iPlot} - Under works ..."
    
    iPlotFile="${analysisID}_${iPlot}.dat"

    if (! test -s "${iPlotFile}")
    then
        echo "  Pb in producing the dat plot (${iPlotFile})... exit !"
        exit -2
    else
        export  RivetVersion=`rivet --version`
        export  NbTotEvts=`expr ${NbSubjobs} \* ${NbEvtsPerSubjob}`
                NbTotEvts=`printf "%.2e" ${NbTotEvts} | awk -F 'e+' '{print "$" $1 ".10^{" $2 "}$"}'`
                
cat <<-EOF >> ${iPlotFile}
# Append the .dat file
# BEGIN SPECIAL system
\rput[Bl]{O}(0.7, 0.85){${TLaTeXInfo}}
# END SPECIAL

# BEGIN SPECIAL Rivet-version
\rput[Bl]{270}(1.03, 0.9){\footnotesize ( ${RivetVersion} / MC stat. : ${NbTotEvts} evts )}
# END SPECIAL

# See https://en.wikibooks.org/wiki/LaTeX/PSTricks#Text
# \rput[anchor]{angle}(x,y){texte}
# Reference =
# Available anchors:
#     B, Bl, Br: writing baseline center, left and right.
#     t, tl, tr: top  center, left and right of the box
#     b, bl, br: bottom center, left and right of the box

EOF

        make-plots --format=png,pdf --font=times ${iPlotFile}  # format=png,eps,pdf

    fi # end if iPlot.dat exist




done # end loop iPlot


exit 1


