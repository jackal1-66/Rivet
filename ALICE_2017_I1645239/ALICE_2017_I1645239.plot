BEGIN PLOT /ALICE_2017_I1645239/d01-x01-y01
Title=Prompt $\Lambda_c^+$ cross section in pp at 7 TeV and $|y|<0.5$. 
XLabel=$p_T$ [GeV/c]
#PlotSize=10,8
#LegendYPos=0.96
#LegendXPos=0.55
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
RatioPlotYMin=0.01
RatioPlotYMax=1.2
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d02-x01-y01
Title=Prompt $\Lambda_c^+$ cross section in p-Pb at 5.02 TeV and $-0.96<y<0.04$.
XLabel=$p_T$ [GeV/c]
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
#PlotSize=10,8
#LegendYPos=0.96
#LegendXPos=0.55i
RatioPlotYMin=0.01
RatioPlotYMax=1.2
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d03-x01-y01
Title=$\Lambda_c^+/D^0$ ratio in pp at $\sqrt{s}=7$ TeV and $|y|<0.5$.
XLabel=$p_T$ [GeV/c]
#YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
#PlotSize=10,8
#LegendYPos=0.96
#LegendXPos=0.55
LogY=0
RatioPlotYMin=0.01
RatioPlotYMax=1.15
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d04-x01-y01
Title=$\Lambda_c^+/D^0$ ratio in p-Pb at $\sqrt{s_{NN}}=5.02$ TeV and $-0.96<y<0.04$.
XLabel=$p_T$ [GeV/c]
#YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
RatioPlotYMin=0.01
RatioPlotYMax=1.15
#PlotSize=10,8
LogY=0
LegendYPos=0.95
LegendXPos=0.53
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d05-x01-y01
Title=Integrated $\Lambda_c^+/D^0$ in pp at 7 TeV and $|y|<0.5$  
XLabel= y
#YLabel=$N(D^+)/N(D^0)$
ConnectBins=0
RatioPlotYMin=0.01
RatioPlotYMax=1.2
#PlotSize=10,8
LegendYPos=0.68
LegendXPos=0.53
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d06-x01-y01
Title=Integrated $\Lambda_c^+/D^0$ in pPb at 5.02 TeV and $-0.96 < y < 0.04$
XLabel= y
#YLabel=$N(D^{*+})/N(D^0)$
ConnectBins=0
RatioPlotYMin=0.01
RatioPlotYMax=1.2
#PlotSize=10,8
LegendYPos=0.68
LegendXPos=0.53
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d07-x01-y01
Title=$\Lambda_c^+$ $R_{pPb}$ p-Pb collisions at 5.02 TeV and $-0.96 < y < 0.04$. 
XLabel= $p_T$ [GeV/c]
YLabel= $\Lambda_c^+ R_{pPb}$
ConnectBins=0
RatioPlotYMin=0.01
RatioPlotYMax=1.15
#PlotSize=10,8
LogY=0
LegendYPos=0.95
LegendXPos=0.30
YMax = 2
YMin = 0.2
# + any additional plot settings you might like, see make-plots documentation
END PLOT
