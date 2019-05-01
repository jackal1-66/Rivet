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
      declare(UnstableFinalState(Cuts::absrap < 0.5), "UFS");

      // Book histograms
      _h_D0 = bookHisto1D(1, 1, 1);
      _h_Dplus = bookHisto1D(2, 1, 1);
      _h_Dstar = bookHisto1D(3, 1, 1);
      _h_Ds = bookHisto1D(4, 1, 1);
      _h_DplusonD0 = bookHisto1D(5, 1, 1);
      _h_DstaronD0 = bookHisto1D(6, 1, 1);
      _h_DsonD0 = bookHisto1D(7, 1, 1);
      _h_DsonDplus = bookHisto1D(8, 1, 1);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {
        const double weight = event.weight();
        const UnstableFinalState& ufs = apply<UnstableFinalState>(event, "UFS");
        
        foreach (const Particle& p, ufs.particles()) {
            if(p.fromBottom())
                continue;
            else
                {    
                if(p.abspid() == 421){
                    _h_D0->fill(p.pT()/GeV, weight); 
                    _h_integ->fill(1,weight);}
                else if(p.abspid() == 411){
                    _h_Dplus->fill(p.pT()/GeV, weight);
                    _h_integ->fill(2,weight);}
                else if(p.abspid()== 413){
                    _h_Dstar->fill(p.pT()/GeV, weight);    
                    _h_integ->fill(3,weight);}
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

    }

    //@}


    /// @name Histograms
    //@{
    Histo1DPtr _h_D0, _h_Dplus, _h_Dstar, _h_Ds, _h_DplusonD0, _h_DstaronD0, _h_DsonD0, _h_DsonDplus;
    //@}


  };


  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2017_I1511870);


}
