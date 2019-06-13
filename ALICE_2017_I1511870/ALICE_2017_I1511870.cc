// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/UnstableFinalState.hh"

namespace Rivet {


  /// @brief Add a short analysis description here
  class ALICE_2017_I1511870 : public Analysis {
  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2017_I1511870);


    /// @name Analysis methods
    //@{

    /// Book histograms and initialise projections before the run
    void init() {

      // Initialise and register projections
      declare(UnstableFinalState(), "UFS");
      
      std::vector<double> binEdges0 = {0., 1., 2., 3., 4., 5., 6., 7., 8., 10., 12., 16., 24., 36.};
      std::vector<double> binEdges = {1., 2., 3., 4., 5., 6., 7., 8., 10., 12., 16., 24.};
      std::vector<double> binEdges1 = {2., 4., 6., 8., 12.};
      double binEdge = 7.000000e+03/GeV;

      // Book histograms
      _h_D0 = bookHisto1D("d01-x01-y01", binEdges0, "D0");
      _h_Dplus = bookHisto1D("d02-x01-y01", binEdges, "Dplus");
      _h_Dstar = bookHisto1D("d03-x01-y01", binEdges, "Dstar");
      _h_Ds = bookHisto1D("d04-x01-y01", binEdges1, "Ds");
      _h_DplusonD0 = bookScatter2D("d05-x01-y01", binEdges, "DplusonD0");
      _h_DstaronD0 = bookScatter2D("d06-x01-y01", binEdges, "DstaronD0");
      _h_DsonD0 = bookScatter2D("d07-x01-y01", binEdges1, "DsonD0");
      _h_DsonDplus = bookScatter2D("d08-x01-y01", binEdges1, "DsonDplus");
      _h_D0int = bookHisto1D("d09-x01-y01", binEdge, "D0int");
      _h_Dplusint = bookHisto1D("d10-x01-y01", binEdge, "Dplusint");
      _h_Dstarint = bookHisto1D("d11-x01-y01", binEdge, "Dstarint");
      _h_Dsint = bookHisto1D("d12-x01-y01", binEdge, "Dsint");
      _h_cc = bookHisto1D("d13-x01-y01", binEdge, "cc");
      _h_ptd0 = bookHisto1D("d14-x01-y01", binEdge, "ptd0");
      _h_D0full = bookHisto1D("d15-x01-y01", binEdge, "D0full");
      _h_ccfull = bookHisto1D("d16-x01-y01", binEdge, "ccfull");
      _h_D0dummy = bookHisto1D("_h_D0dummy", binEdges, "D0 cross section for ratios");
      _h_D0dummy1 = bookHisto1D("_h_D0dummy1", binEdges1, "D0 cross section for Ds ratio");
      _h_Dplusdummy = bookHisto1D("_h_Dplusdummy", binEdges1, "Dplus cross section for Ds ratio");
      
    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {
        const double weight = event.weight();
        const UnstableFinalState& ufs = apply<UnstableFinalState>(event, "UFS");
        
        foreach (const Particle& p, ufs.particles()) {
          if(p.abspid() == 421){
              if(not p.fromBottom()){
                  _h_D0full->fill(7.000000e+03/GeV,weight);    
                  _h_ccfull->fill(7.000000e+03/GeV,weight);}}
          if(p.absrap() < 0.5){
            if(p.fromBottom())
                continue;
            else
                {    
                if(p.abspid() == 421){
                    _h_D0->fill(p.pT()/GeV, weight); 
                    _h_D0dummy->fill(p.pT()/GeV, weight);
                    _h_D0dummy1->fill(p.pT()/GeV, weight);
                    _h_D0int->fill(7.000000e+03/GeV, weight);
                    _h_cc->fill(7.000000e+03/GeV, weight);
                    _h_ptd0->fill(7.000000e+03/GeV,p.pT()/GeV,weight);
                    }
                else if(p.abspid() == 411){
                    _h_Dplus->fill(p.pT()/GeV, weight);
                    _h_Dplusdummy->fill(p.pT()/GeV, weight);
                    _h_Dplusint->fill(7.000000e+03/GeV, weight); 
                    }
                else if(p.abspid() == 413){
                    _h_Dstar->fill(p.pT()/GeV, weight); 
                    _h_Dstarint->fill(7.000000e+03/GeV, weight);    
                    }
                else if(p.abspid() == 431){
                    _h_Ds->fill(p.pT()/GeV, weight);
                    _h_Dsint->fill(7.000000e+03/GeV, weight); 
                }    
                }
        }
        }  
    }            


    /// Normalise histograms etc., after the run
    void finalize() {

      //normalize(_h_YYYY); // normalize to unity
      scale(_h_D0, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dplus, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dstar, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Ds, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_D0dummy, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_D0dummy1, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dplusdummy, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      divide(_h_Dplus,_h_D0dummy,_h_DplusonD0); //ratio plots
      divide(_h_Dstar,_h_D0dummy,_h_DstaronD0);
      divide(_h_Ds,_h_D0dummy1,_h_DsonD0);
      divide(_h_Ds,_h_Dplusdummy,_h_DsonDplus);
      scale(_h_D0int, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dplusint, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dstarint, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dsint, crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_cc, crossSection()/(microbarn*sumOfWeights()*0.542));
      scale(_h_ptd0, 1/sumOfWeights());
      scale(_h_D0full,crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_ccfull, crossSection()/(microbarn*sumOfWeights()*0.542));
    }

    //@}


    /// @name Histograms
    //@{
    Histo1DPtr _h_D0, _h_Dplus, _h_Dstar, _h_Ds, _h_D0int, _h_Dplusint, _h_Dstarint, _h_Dsint, _h_cc, _h_D0full, _h_ptd0, _h_D0dummy, _h_D0dummy1, _h_Dplusdummy , _h_ccfull;
    Scatter2DPtr _h_DplusonD0, _h_DstaronD0, _h_DsonD0, _h_DsonDplus;
    int d0num=0;
    float cfrac=0, ptm=0;
    //@}


  };


  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2017_I1511870);


}
