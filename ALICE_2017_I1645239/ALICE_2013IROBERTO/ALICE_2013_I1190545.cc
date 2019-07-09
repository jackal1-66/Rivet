// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/ChargedFinalState.hh"
#include "Rivet/Projections/FastJets.hh"

/*
 * 1483543: 
 * Pseudorapidity density of charged particles p-Pb collisions at √sNN = 5.02 TeV [ALICE]
 *
 * https://doi.org/10.1103/PhysRevLett.110.032301
 * http://inspirehep.net/record/1190545
 * https://hepdata.net/record/ins1190545
 *
 * Author: preghenella@bo.infn.it (R+)
 * (during the Rivet for Heavy-Ions Workshop, NBI, August 2018)
 * 
 */

namespace Rivet {

  /// @brief Add a short analysis description here
  class ALICE_2013_I1190545 : public Analysis {
  public:

    /// Constructor
    DEFAULT_RIVET_ANALYSIS_CTOR(ALICE_2013_I1190545);

    /// check for weak-decay daughters 
    bool isFromWeakDecay(const Particle& p) const {
      if ( p.hasAncestor(310)  || p.hasAncestor(-310)  ||     // K0s
	   p.hasAncestor(130)  || p.hasAncestor(-130)  ||     // K0l
	   p.hasAncestor(3322) || p.hasAncestor(-3322) ||     // Xi0
	   p.hasAncestor(3122) || p.hasAncestor(-3122) ||     // Lambda
	   p.hasAncestor(3222) || p.hasAncestor(-3222) ||     // Sigma+/-
	   p.hasAncestor(3312) || p.hasAncestor(-3312) ||     // Xi-/+ 
	   p.hasAncestor(3334) || p.hasAncestor(-3334) )      // Omega-/+
	return true;
      
      return false;
    }
    
    /// @name Analysis methods
    //@{

    /// Book histograms and initialise projections before the run
    void init() {

      // Initialise and register projections

      declare(ChargedFinalState(Cuts::abseta < 2.0), "CFS");

      // Book histograms

      _h_dNdEta = bookHisto1D(1, 1, 1);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      /// @todo Do the event by event analysis here

      const double weight = event.weight();
      const ChargedFinalState& cfs = apply<ChargedFinalState>(event, "CFS");

      // loop over charged final state particles 
      foreach (const Particle& p, cfs.particles()) {
	if (isFromWeakDecay(p)) continue;
	_h_dNdEta->fill(p.eta(), weight);
      }
    }


    /// Normalise histograms etc., after the run
    void finalize() {
      scale(_h_dNdEta, 1. / sumOfWeights());
    }

    //@}


    /// @name Histograms
    //@{
    Histo1DPtr _h_dNdEta;
    //@}


  };


  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2013_I1190545);


}
