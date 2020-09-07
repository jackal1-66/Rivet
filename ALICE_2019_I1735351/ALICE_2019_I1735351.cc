// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/UnstableParticles.hh"


namespace Rivet {


  /// @brief Add a short analysis description here
  class ALICE_2019_I1735351 : public Analysis {
  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2019_I1735351);


    /// @name Analysis methods
    ///@{

    /// Book histograms and initialise projections before the run
    void init() {

      // Initialise and register projections

      // The basic final-state projection:
      // all final-state particles within
      // the given eta acceptance
      declare(UnstableFinalState(Cuts::absrap < 0.9), "ups");

      book(_h_JPsi_int,1,1,1);
      book(_h_JPsi_diff,2,1,1);
      book(_h_JPsi_pt2,3,1,1);
      book(_h_JPsi_ptmean,4,1,1);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      const double weight = event.weight();
      const UnstableFinalState& ufs = apply<UnstableFinalState>(event, "ufs");

      foreach (const Particle& p, ups.particles()) {
        if(p.abspid()==443){
          _h_JPsi_int->Fill(0, weight);
          _h_JPsi_diff->Fill(p.pT()/GeV, weight);
          _h_JPsi_pt2->Fill(5.02, weigth*TMath::Power(p.pT(),2));
          _h_JPsi_ptmean->Fill(5.02, weigth*p.pT());
        }
      }
      
    }


    /// Normalise histograms etc., after the run
    void finalize() {

      scale(_h_JPsi_int,      crossSection()/(microbarn*2*sumW())); // norm to generated cross-section in pb (after cuts)
      scale(_h_JPsi_diff,     crossSection()/(microbarn*2*sumW()));
      scale(_h_JPsi_pt2,      1/(2*sumW());
      scale(_h_JPsi_ptmean,   1/(2*sumW()));

    }

    ///@}


    /// @name Histograms
    ///@{
    Histo1DPtr _h_JPsi_int, _h_JPsi_diff, _h_JPsi_pt2, _h_JPsi_ptmean;
    ///@}


  };


  DECLARE_RIVET_PLUGIN(ALICE_2019_I1735351);

}
