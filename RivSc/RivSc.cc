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
      const UnstableParticles fs(Cuts::abseta < 0.9);
      declare(fs, "fs");  

      book(_h_JPsi_int,1,1,1);
      book(_h_JPsi_diff,2,1,1);
      book(_h_JPsi_pt2,3,1,1);
      book(_h_JPsi_ptmean,4,1,1);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      const UnstableParticles& fs = apply<UnstableParticles>(event, "fs");
      
      for (const Particle& p : fs.particles()) {
        if(p.abspid()==443){
          j+=1;
	  std::cout << "Here's a J/Psi, total counted are " << j << endl;
          std::cout << "Pt is " << p.pT()/GeV << endl;
          _h_JPsi_int->fill(0);
          _h_JPsi_diff->fill(p.pT()/GeV);
          _h_JPsi_pt2->fill(5.02,p.pT()/GeV*p.pT()/GeV);
          _h_JPsi_ptmean->fill(5.02,p.pT()/GeV);
        }
      }
      
    }


    /// Normalise histograms etc., after the run
    void finalize() {

      scale(_h_JPsi_int,      crossSection()/(microbarn*2*sumOfWeights())); // norm to generated cross-section in pb (after cuts)
      scale(_h_JPsi_diff,     crossSection()/(microbarn*2*sumOfWeights()));
      scale(_h_JPsi_pt2,      1/(2*sumOfWeights()));
      scale(_h_JPsi_ptmean,   1/(2*sumOfWeights()));

    }

    ///@}


    /// @name Histograms
    ///@{
    Histo1DPtr _h_JPsi_int, _h_JPsi_diff, _h_JPsi_pt2, _h_JPsi_ptmean;
    int j = 0;
    ///@}


  };


  DECLARE_RIVET_PLUGIN(RivSc);

}
