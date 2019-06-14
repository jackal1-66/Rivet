BEGIN PLOT /ALICE_2012_I944757/d01-x01-y01
Title=Differential cross section for prompt $D^0$ production.
XLabel=$p_T$ [GeV/c]
#PlotSize=10,8
LegendYPos=0.93
LegendXPos=0.45
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
RatioPlotYMax=1.8
XMin=0
CustomLegend=|y| < 0.5
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2012_I944757/d02-x01-y01
Title=Differential cross section for prompt $D^+$ production.
XLabel=$p_T$ [GeV/c]
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
#PlotSize=10,8
LegendYPos=0.93
LegendXPos=0.45
RatioPlotYMax=1.8
XMin=0
CustomLegend=|y| < 0.5
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2012_I944757/d03-x01-y01
Title=Differential cross section for prompt $D^{*+}$ production.
XLabel=$p_T$ [GeV/c]
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
#PlotSize=10,8
LegendYPos=0.93
LegendXPos=0.45
RatioPlotYMax=1.8
XMin=0
CustomLegend=|y| < 0.5
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2012_I944757/d04-x01-y01
Title=Integrated cross sections for prompt charm particle production. 
XLabel=pp\to D$^0$ X;\qquad \qquad \qquad pp\to D$^+$ X;\qquad \qquad \qquad pp\to D$^{*+}$ X. 
YLabel=$\frac{\text{d}\sigma}{\text{d}y}$ [$\mu$b]
ConnectBins=0
#RatioPlotYMin=0.1
#PlotSize=10,8
LegendYPos=0.93
LegendXPos=0.45
XMin=0
CustomLegend=|y| < 0.5
# + any additional plot settings you might like, see make-plots documentation
END PLOT

# ... add more histograms as you need them ...
