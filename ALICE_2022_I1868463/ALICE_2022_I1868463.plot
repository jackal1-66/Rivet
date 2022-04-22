BEGIN PLOT /ALICE_2022_I1868463/d01-x01-y01
Title=Differential D$^0$ production cross section vs $p_T$
XLabel=$p_T$ [GeV/$c$]
YLabel=D$^0$ $\sigma$
#LogY=0
#YMax=0.52 
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2022_I1868463/d02-x01-y01
Title=Differential $\Lambda_c$ production cross section vs $p_T$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Lambda_c^+$ $\sigma$
#LogY=0
#YMax=0.52 
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2022_I1868463/d03-x01-y01
Title=Differential $\Sigma_c$ production cross section vs $p_T$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Sigma_c^{0,+,++}$ $\sigma$
#LogY=0
#YMax=1.2
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9

# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2022_I1868463/d04-x01-y01
Title=Differential $\Lambda_c$ from $\Sigma_c^{0,+,++}$ production cross section vs $p_T$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Lambda_c^+$($\leftarrow \Sigma_c^{0,+,++}$) $\sigma$
#LogY=0
#YMax=1.2
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9

# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2022_I1868463/d05-x01-y01
Title=Average ratio of $\Lambda_c^+$ and $D^0$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Lambda_c^+$/$D0$
#LogY=0
#YMax=1.2
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9

# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2022_I1868463/d06-x01-y01
Title=Average ratio of $\Sigma_c^{0,+,++}$ and $D^0$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Sigma_c^{0,+,++}$/$D0$
#LogY=0
YMax=1.5
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9

# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2022_I1868463/d07-x01-y01
Title=Average ratio of $\Lambda_c^+$ from $\Sigma_c^{0,+,++}$ and $\Lambda_c^+$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Lambda_c^+$($\leftarrow \Sigma_c^{0,+,++}$)/$\Lambda_c^+$
#LogY=0
YMax=2
#YMin=0.
LegendXPos=0.49
#RatioPlotYMin=0.01
#RatioPlotYMax=1.9

# + any additional plot settings you might like, see make-plots documentation
END PLOT

# ... add more histograms as you need them ...

