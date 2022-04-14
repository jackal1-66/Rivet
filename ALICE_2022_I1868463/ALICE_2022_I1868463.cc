// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/UnstableParticles.hh"


namespace Rivet {


  /// @brief Add a short analysis description here
  class ALICE_2022_I1868463 : public Analysis {
  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2022_I1868463);


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

      book(_h_D0,1,1,1);
      book(_h_Lc,2,1,1);
      book(_h_Sc,3,1,1);
      book(_h_LcfromSc,4,1,1);
      book(_h_LcD0,5,1,1);
      book(_h_ScD0,6,1,1);
      book(_h_LcfromScLc,7,1,1);
      book(_h_D04Sc,"TMP/D04Sc",refData(3,1,1));
      book(_h_Lc4Ratio, "TMP/Lc4Ratio", refData(4,1,1));

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      const UnstableParticles& up = apply<UnstableParticles>(event, "up");
      
      for (const Particle& p : up.particles()) {
        if(p.fromBottom())
          continue;
        else{
          if(p.abspid()==4222 || p.abspid()==4212 || p.abspid()==4112)
            _h_Sc->fill(p.pT()/GeV);
          else if(p.abspid()==4122){
            _h_Lc->fill(p.pT()/GeV);
            _h_Lc4Ratio->fill(p.pT()/GeV);
            if(p.hasAncestor(4222) || p.hasAncestor(4212) || p.hasAncestor(4112) || p.hasAncestor(-4222) || p.hasAncestor(-4212) || p.hasAncestor(-4112))
              _h_LcfromSc->fill(p.pT()/GeV);
          }
          else if(p.abspid()==421){
            _h_D0->fill(p.pT()/GeV);
            _h_D04Sc->fill(p.pT()/GeV);
          }
        }    
      }      
    }


    /// Normalise histograms etc., after the run
    void finalize() {
      
      scale(_h_D0,              crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_Lc,              crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_LcfromSc,        crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_Lc4Ratio,        crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_Sc,              crossSection()/(microbarn*2*sumOfWeights())); 
      scale(_h_D04Sc,           crossSection()/(microbarn*2*sumOfWeights())); // norm to generated cross-section in pb (after cuts)
      divide(_h_Sc, _h_D04Sc, _h_ScD0);
      divide(_h_Lc, _h_D0, _h_LcD0);
      divide(_h_LcfromSc, _h_Lc4Ratio, _h_LcfromScLc);

    }

    ///@}


    /// @name Histograms
    ///@{
    Histo1DPtr _h_Sc, _h_D0, _h_D04Sc, _h_LcfromSc, _h_Lc , _h_Lc4Ratio;
    Scatter2DPtr _h_LcD0, _h_ScD0, _h_LcfromScLc;
    ///@}


  };


  DECLARE_RIVET_PLUGIN(ALICE_2022_I1868463);

}
