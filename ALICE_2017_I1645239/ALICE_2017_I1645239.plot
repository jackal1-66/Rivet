BEGIN PLOT /ALICE_2017_I1645239/d01-x01-y01
Title=Prompt $\Lambda_c^+ p_T$ differential cross section in pp at $\sqrt{s}=7$ TeV and $|y|<0.5$. 
XLabel=$p_T$ [GeV/c]
#PlotSize=10,8
#LegendYPos=0.96
#LegendXPos=0.55
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
RatioPlotYMin=0.1
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d02-x01-y01
Title=Prompt $\Lambda_c^+ p_T$ differential cross section in p-Pb at $\sqrt{s_{NN}} = $5.02 TeV and $-0.96<y<0.04$.
XLabel=$p_T$ [GeV/c]
YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
#PlotSize=10,8
#LegendYPos=0.96
#LegendXPos=0.55
RatioPlotYMin=0.1
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
RatioPlotYMin=0.1
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d04-x01-y01
Title=$\Lambda_c^+/D^0$ ratio in p-Pb at $\sqrt{s_{NN}}=5.02$ TeV and $-0.96<y<0.04$.
XLabel=$p_T$ [GeV/c]
#YLabel=$\frac{\text{d}\sigma}{\text{d}p_T}$ [$\mu$b/GeV]
ConnectBins=0
RatioPlotYMin=0.1
#PlotSize=10,8
LogY=0
LegendYPos=0.95
LegendXPos=0.55
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d05-x01-y01
Title=$\Lambda_c^+/D^0$ ratio in pp at $\sqrt{s}=7$ TeV and $|y|<0.5$ with $1 < p_T < 8$ GeV/c.  
XLabel= $p_T$ [GeV/c]
#YLabel=$N(D^+)/N(D^0)$
ConnectBins=0
RatioPlotYMin=0.1
#PlotSize=10,8
LegendYPos=0.95
LegendXPos=0.55
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d06-x01-y01
Title=$\Lambda_c^+/D^0$ ratio in pPb at $\sqrt{s_{NN}}=5.02$ TeV and $-0.96 < y < 0.04$ with $2 < p_T < 12$ GeV/c.
XLabel= $p_T$ [GeV/c]
#YLabel=$N(D^{*+})/N(D^0)$
ConnectBins=0
RatioPlotYMin=0.1
#PlotSize=10,8
LegendYPos=0.95
LegendXPos=0.55
# + any additional plot settings you might like, see make-plots documentation
END PLOT

BEGIN PLOT /ALICE_2017_I1645239/d07-x01-y01
Title=$R_{pPb}$ of prompt $\Lambda_c^+$ in p-Pb collisions at $\sqrt{s_{NN}}=5.02$ and $-0.96 < y < 0.04$. 
XLabel= $p_T$ [GeV/c]
YLabel= $\Lambda_c^+ R_{pPb}$
ConnectBins=0
RatioPlotYMin=0.1
#PlotSize=10,8
LogY=0
LegendYPos=0.95
LegendXPos=0.55
YMin = 0.
# + any additional plot settings you might like, see make-plots documentation
END PLOT
