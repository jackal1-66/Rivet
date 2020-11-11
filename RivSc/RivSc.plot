BEGIN PLOT /RivSc/d01-x01-y01
Title=Ratio $\Sigma_c^{0,+,++}$/$D0$ production cross sections vs $p_T$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Sigma_c^{0,+,++}$/$D0$
LogY=0
YMax=0.52 
YMin=0.
LegendXPos=0.45
RatioPlotYMin=0.01
RatioPlotYMax=1.9
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /RivSc/d02-x01-y01
Title=Average ratio of $\Lambda_c^+$ from $\Sigma_c^{0,+,++}$ and $\Lambda_c^+$
XLabel=$p_T$ [GeV/$c$]
YLabel=$\Lambda_c^+$($\leftarrow \Sigma_c^{0,+,++}$)/$\Lambda_c^+$
LogY=0
YMax=1.2
YMin=0.
LegendXPos=0.45
RatioPlotYMin=0.01
RatioPlotYMax=1.9

# + any additional plot settings you might like, see make-plots documentation
END PLOT

# ... add more histograms as you need them ...
