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
      declare(FinalState(Cuts::abseta < 5 && Cuts::pT > 100*MeV), "FS");

      // Book histograms
      _h_XXXX = bookHisto1D(1, 1, 1);
      _p_AAAA = bookProfile1D(2, 1, 1);
      _c_BBBB = bookCounter(3, 1, 1);

    }


    /// Perform the per-event analysis
    void analyze(const Event& event) {

      /// @todo Do the event by event analysis here

    }


    /// Normalise histograms etc., after the run
    void finalize() {

      normalize(_h_YYYY); // normalize to unity
      scale(_h_ZZZZ, crossSection()/picobarn/sumOfWeights()); // norm to cross section

    }

    //@}


    /// @name Histograms
    //@{
    Histo1DPtr _h_XXXX, _h_YYYY, _h_ZZZZ;
    Profile1DPtr _p_AAAA;
    CounterPtr _c_BBBB;
    //@}


  };


  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2017_I1511870);


}
