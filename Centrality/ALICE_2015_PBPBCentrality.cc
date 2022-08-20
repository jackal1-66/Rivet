#include <Rivet/Analysis.hh>
#include <Rivet/Projections/AliceCommon.hh>
#include <Rivet/Projections/HepMCHeavyIon.hh>

namespace Rivet {

  /// Dummy analysis for centrality calibration in Pb-Pb at 5.02TeV
  ///
  /// @author Christian Holm Christensen <cholm@nbi.dk>
  class ALICE_2015_PBPBCentrality : public Analysis {
  public:

    /// Constructor 
    ALICE_2015_PBPBCentrality()
      : Analysis("ALICE_2015_PBPBCentrality")
    {    }

    /// Initialize this analysis. 
    void init() {
      ALICE::V0AndTrigger v0and;
      declare<ALICE::V0AndTrigger>(v0and,"V0-AND");

      ALICE::V0MMultiplicity v0m;
      declare<ALICE::V0MMultiplicity>(v0m,"V0M");

       // Access the HepMC heavy ion info
      declare(HepMCHeavyIon(), "HepMC");

      book(_v0m, "V0M", 20000, 0, 20000);
      book(_imp, "V0M_IMP",100,0,20);
    }


    /// Analyse a single event.
    void analyze(const Event& event) {
      // Get and fill in the impact parameter value if the information is valid.
      _imp->fill(apply<HepMCHeavyIon>(event, "HepMC").impact_parameter());

      // Check if we have any hit in either V0-A or -C.  If not, the
      // event is not selected and we get out.
      if (!apply<ALICE::V0AndTrigger>(event,"V0-AND")()) return;

      // Fill in the V0 multiplicity for this event
      _v0m->fill(apply<ALICE::V0MMultiplicity>(event,"V0M")());
    }


    /// Finalize this analysis
    void finalize() {
      _v0m->normalize();
      _imp->normalize();
    }

    /// The distribution of V0M multiplicity
    Histo1DPtr _v0m;
    /// The distribution of impact parameters
    Histo1DPtr _imp;

  };


  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2015_PBPBCentrality);

}