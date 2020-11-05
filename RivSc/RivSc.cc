// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/UnstableParticles.hh"


namespace Rivet {


  /// @brief Add a short analysis description here
  class RivSc : public Analysis {
  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(RivSc);


    /// @name Analysis methods
    ///@{

    /// Book histograms and initialise projections before the run
    void init() {

      // Initialise and register projections

      // The basic final-state projection:
      // all final-state particles within
      // the given eta acceptance
      const UnstableParticles up(Cuts::absrap < 0.5);
      declare(up, "up");  

      book(_h_ScD0,1,1,1);
      book(_h_LcfromScLc,2,1,1);
      book(_h_Sc,"TMP/Sc",refData(1,1,1));
      book(_h_LcfromSc,"TMP/LcfromSc",refData(2,1,1));
      book(_h_D0,"TMP/D0",refData(1,1,1));

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      const UnstableParticles& up = apply<UnstableParticles>(event, "up");
      
      for (const Particle& p : up.particles()) {
        if(p.abspid()==4222 || p.abspid()==4212 || p.abspid()==4112){
          cout << "Found a Sc, opplà\n";
          _h_Sc->fill(p.pT()/GeV);
        }
        else if(p.abspid()==4122){
          cout << "Found a Lc, Banana\n";
          _h_Lc->fill(p.pT()/GeV);
          if(p.hasAncestor(4222) || p.hasAncestor(4212) || p.hasAncestor(4112) || p.hasAncestor(-4222) || p.hasAncestor(-4212) || p.hasAncestor(-4112))
            _h_LcfromSc->fill(p.pT()/GeV);
        }
        else if(p.abspid()==421)
        cout << "Found a D0, Bubu\n";
          _h_D0->fill(p.pT()/GeV);
      }
      
    }


    /// Normalise histograms etc., after the run
    void finalize() {

      scale(_h_Sc,           crossSection()/(microbarn*2*sumOfWeights())); // norm to generated cross-section in pb (after cuts)
      scale(_h_LcfromSc,     crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_D0,           crossSection()/(microbarn*2*sumOfWeights()));
      divide(_h_Sc, _h_D0, _h_ScD0);
      divide(_h_LcfromSc, _h_Lc, _h_LcfromScLc);

    }

    ///@}


    /// @name Histograms
    ///@{
    Histo1DPtr _h_Sc, _h_D0, _h_LcfromSc, _h_Lc;
    Scatter2DPtr _h_ScD0, _h_LcfromScLc;
    ///@}


  };


  DECLARE_RIVET_PLUGIN(RivSc);

}
