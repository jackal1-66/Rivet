#ifndef PROJECTIONS_ALICECOMMON_HH
#define PROJECTIONS_ALICECOMMON_HH
#include "Rivet/Tools/AliceCommon.hh"
#include "Rivet/Projections/FinalState.hh"
#include "Rivet/Projections/SingleValueProjection.hh"
#include "Rivet/Projections/TriggerProjection.hh"
#include "Rivet/Projections/PrimaryParticles.hh"

namespace Rivet {
  namespace ALICE {

    /// @todo We should avoid experiment-specific projections and tools as much as possible...
    /// Says Leif: on the contrary this is a good thing!


    /// Template for ALICE V0 multiplicity projection.   Which
    /// acceptance to look in depends on the template argument @a MODE:
    ///
    /// - @c MODE=-1  Check the V0-C acceptance (@f$-3.7<\eta<-1.7@f$)
    /// - @c MODE=+1  Check the V0-A acceptance (@f$+2.8<\eta<+5.1@f$)
    /// - @c MODE=0   Check both V0-A and -C acceptances (sum)
    ///
    /// @ingroup alice_rivet
    template <int MODE>
    class V0Multiplicity : public SingleValueProjection {
    public:
      V0Multiplicity(double avgV0Mult = 1.) : SingleValueProjection() {
        setName(MODE<0 ? "ALICE::V0CMultiplicity":
		MODE>0 ? "ALICE::V0AMultiplicity":
		"ALICE::V0MMultiplicity");
        _avgV0Mult = avgV0Mult;
        Cut cut;
        if      (MODE < 0) cut = V0Cacceptance;
        else if (MODE > 0) cut = V0Aacceptance;
        else               cut = (V0Aacceptance || V0Cacceptance);
        // Declare our projection.  Note, the cuts stipulate charged
        // particles, so we just use a final state (rather than
        // charged-final state) projection here.
        const FinalState fs(cut);
        this->declare(fs, "FinalState");
      }

      /// Destructor
      virtual ~V0Multiplicity() {}

      /// Do the projection.  Sums number of charged final state
      /// particles within the acceptances of the specified V0
      /// sub-detectors.
      ///
      /// @param e Event to project from
      virtual void project(const Event& e) {
        clear();
        set(apply<FinalState>(e,"FinalState").particles().size()/_avgV0Mult);
      }

      /// Clone this projection
      ///
      /// @return New wrapped pointer to object of this class
      virtual std::unique_ptr<Rivet::Projection> clone() const {
        return std::unique_ptr<Projection>(new V0Multiplicity<MODE>(*this));
      }
      /// Compare to another projection
      ///
      /// @param p Projection to compare against
      virtual CmpState compare(const Projection& p) const {
	return dynamic_cast<const V0Multiplicity<MODE>*>(&p) ?
	  CmpState::EQ : CmpState::NEQ;
      }

      double _avgV0Mult = 1.;

    };

    /// Convenience typedef for A-side multiplicity
    ///
    /// @ingroup alice_rivet
    typedef V0Multiplicity<+1> V0AMultiplicity;

    /// Convenience typedef for C-side multiplicity
    ///
    /// @ingroup alice_rivet
    typedef V0Multiplicity<-1> V0CMultiplicity;

    /// Convenience typedef for A & C multiplicity
    ///
    /// @ingroup alice_rivet
    typedef V0Multiplicity<0> V0MMultiplicity;



    /// Template for ALICE CL multiplicity projection.  Which
    /// acceptance to look in depends on the template argument @a INNER:
    ///
    /// - @c INNER=true Check the inner SPD layer
    /// - @c INNER=false  Check the outer SPD layer
    ///
    /// @ingroup alice_rivet
    template <bool INNER>
    class CLMultiplicity : public SingleValueProjection {
    public:

      /// Constructor
      CLMultiplicity() : SingleValueProjection() {
        setName("ALICE::CLMultiplicity");
        Cut cut;
        if   (INNER) cut = CL0acceptance;
        else         cut = CL1acceptance;
        // Declare our projection.  Note, the cuts stipulate charged
        // particles, so we just use a final state (rather than
        // charged-final state) projection here.
        const FinalState fs(cut);
        this->declare(fs, "FinalState");
      }

      /// Destructor
      virtual ~CLMultiplicity() {}

      /// Do the projection.  Sums number of charged final state
      /// particles within the acceptances of the specified CL
      /// sub-detectors.
      ///
      /// @param e Event to project from
      virtual void project(const Event& e) {
        clear();
        set(apply<FinalState>(e,"FinalState").particles().size());
      }

      /// Clone this projection
      ///
      /// @return New wrapped pointer to object of this class
      virtual std::unique_ptr<Rivet::Projection> clone() const {
        return std::unique_ptr<Projection>(new CLMultiplicity<INNER>(*this));
      }

      /// Compare to another projection
      ///
      /// @param p Projection to compare against
      virtual CmpState compare(const Projection& p) const {
	return dynamic_cast<const CLMultiplicity<INNER>*>(&p) ?
	  CmpState::EQ : CmpState::NEQ;
      }

    };


    /// Convenience typedef for inside-CL multiplicity
    ///
    /// @ingroup alice_rivet
    typedef CLMultiplicity<true>  CL0Multiplicity;

    /// Convenience typedef for outside-CL multiplicity
    ///
    /// @ingroup alice_rivet
    typedef CLMultiplicity<false> CL1Multiplicity;

    /// Template for ALICE SPD multiplicity projection.  Which
    /// acceptance to look in depends on the template argument @a LAYER:
    ///
    /// - @c LAYER=0 Check the inner SPD layer
    /// - @c LAYER=1 Check the outer SPD layer
    /// - @c LAYER-1 SPD pseudorapidity acceptance given by the user
    ///
    /// @ingroup alice_rivet
    template <int LAYER>
    class SPDMultiplicity : public SingleValueProjection {
    public:

      /// Constructor
      SPDMultiplicity(double avgCLMult = 1., double minPtCutoff = 50., double absEtaAcc = 0.8) : SingleValueProjection() {
        setName(LAYER==0 ? "ALICE::SPD0Multiplicity":
                LAYER==1 ? "ALICE::SPD1Multiplicity":
                           "ALICE::SPDUserMultiplicity");
        _avgCLMult = avgCLMult;
        Cut cut;
        if(LAYER == 0) cut = CL0acceptance && (Cuts::pT > minPtCutoff*MeV);
        else if(LAYER == 1) cut = CL1acceptance && (Cuts::pT > minPtCutoff*MeV);
        else cut = (Cuts::etaIn(-absEtaAcc,+absEtaAcc) && (Cuts::abscharge3 > 0) && (Cuts::pT > minPtCutoff*MeV));
        // Declare our projection.  Note, the cuts stipulate charged
        // particles, so we just use a final state (rather than
        // charged-final state) projection here.
        const FinalState fs(cut);
        this->declare(fs, "FinalState");
      }

      SPDMultiplicity(double avgCLMult, double minPtCutoff, double MinEtaAcc, double MaxEtaAcc) : SingleValueProjection() {
        setName(LAYER==0 ? "ALICE::SPD0Multiplicity":
                LAYER==1 ? "ALICE::SPD1Multiplicity":
                           "ALICE::SPDUserMultiplicity");
        _avgCLMult = avgCLMult;
        Cut cut;
        if(LAYER == 0) cut = CL0acceptance && (Cuts::pT > minPtCutoff*MeV);
        else if(LAYER == 1) cut = CL1acceptance && (Cuts::pT > minPtCutoff*MeV);
        else cut = (Cuts::etaIn(MinEtaAcc,MaxEtaAcc) && (Cuts::abscharge3 > 0) && (Cuts::pT > minPtCutoff*MeV));
        // Declare our projection.  Note, the cuts stipulate charged
        // particles, so we just use a final state (rather than
        // charged-final state) projection here.
        const FinalState fs(cut);
        this->declare(fs, "FinalState");
      }

      /// Destructor
      virtual ~SPDMultiplicity() {}

      /// Do the projection.  Sums number of charged final state
      /// particles within the acceptances of the specified CL
      /// sub-detectors.
      ///
      /// @param e Event to project from
      virtual void project(const Event& e) {
        clear();
        set(apply<FinalState>(e,"FinalState").particles().size()/_avgCLMult);
      }

      /// Clone this projection
      ///
      /// @return New wrapped pointer to object of this class
      virtual std::unique_ptr<Rivet::Projection> clone() const {
        return std::unique_ptr<Projection>(new SPDMultiplicity<LAYER>(*this));
      }

      /// Compare to another projection
      ///
      /// @param p Projection to compare against
      virtual CmpState compare(const Projection& p) const {
    return dynamic_cast<const SPDMultiplicity<LAYER>*>(&p) ?
    CmpState::EQ : CmpState::NEQ;
      }

      double _avgCLMult = 1.;

    };


    /// Convenience typedef for inner-SPD multiplicity
    ///
    /// @ingroup alice_rivet
    typedef SPDMultiplicity<0>  SPD0Multiplicity;

    /// Convenience typedef for outer-SPD multiplicity
    ///
    /// @ingroup alice_rivet
    typedef SPDMultiplicity<1> SPD1Multiplicity;

    /// Convenience typedef for user-defined SPD multiplicity
    ///
    /// @ingroup alice_rivet
    typedef SPDMultiplicity<-1> SPDUserMultiplicity;



     /// A template of ALICE V0-based triggers.
     ///
     /// - @c MODE=-1  Check in the V0-C acceptance (@f$-3.7<\eta<-1.7@f$)
     /// - @c MODE=+1  Check in the V0-A acceptance (@f$+2.8<\eta<+5.1@f$)
     /// - @c MODE=0   Check in both V0-A and -C acceptances (V0-OR)
     ///
     /// @ingroup alice_rivet
    template <int MODE>
    class V0Trigger : public TriggerProjection {
    public:

      /// Constructor
      V0Trigger() : TriggerProjection() {
        setName("ALICE::V0Trigger");
        // Declare our projection.  Note, the cuts stipulate charged
        // particles, so we just use a final state (rather than
        // charged-final state) projection here.
        const V0Multiplicity<MODE> fs;
        this->declare(fs, "FinalState");
      }

      /// Destructor
      virtual ~V0Trigger() {}

       /// Do the projection.  Checks if the number of projected
       /// particles is larger than 0
       ///
       /// @param e Event to project from
      virtual void project(const Event& e) {
        fail(); // Assume failure
        if (apply<V0Multiplicity<MODE>>(e, "FinalState")() > 0) pass();
      }

      /// Clone this projection
      ///
      /// @return New wrapped pointer to object of this class
      virtual std::unique_ptr<Rivet::Projection> clone() const {
        return std::unique_ptr<Projection>(new V0Trigger<MODE>(*this));
      }

      /// Compare to projections.
      ///
      /// @param p Projection to compare to.
      ///
      /// @return true (EQUIVALENT) if the projection @a p is of the same
      /// type as this.
      virtual CmpState compare(const Projection& p) const {
	return dynamic_cast<const V0Trigger<MODE>*>(&p) ?
	  CmpState::EQ : CmpState::NEQ;
      }

    };

    /// Convenience typedef for V0 A trigger
    ///
    /// @ingroup alice_rivet
    using V0ATrigger = V0Trigger<-1>;

    /// Convenience typedef for V0 C trigger
    ///
    /// @ingroup alice_rivet
    using V0CTrigger = V0Trigger<+1>;

    /// Convenience typedef for V0 A-or-C trigger
    ///
    /// @ingroup alice_rivet
    using V0OrTrigger = V0Trigger<0>;



    /// Trigger projection for the ALICE V0-AND (a.k.a. CINT7) requirement
    class V0AndTrigger : public TriggerProjection {
    public:

      /// Constructor
      V0AndTrigger() : TriggerProjection() {
        const V0ATrigger v0a;
        const V0CTrigger v0c;
        this->declare(v0a, "V0A");
        this->declare(v0c, "V0C");
      }

      /// Destructor
      virtual ~V0AndTrigger() {}

       /// Do the projection.  Checks if the numbers of projected
       /// particles on both sides, are larger than 0
       ///
       /// @param e Event to project from
      virtual void project(const Event& e) {
        fail(); // Assume failure
        if (apply<V0ATrigger>(e,"V0A")() && apply<V0CTrigger>(e,"V0C")()) pass();
      }

      /// Compare to projections.
      ///
      /// @param p Projection to compare to.
      virtual CmpState compare(const Projection& p) const
      {
	return dynamic_cast<const V0AndTrigger*>(&p) ?
	  CmpState::EQ : CmpState::NEQ;
      }

       /// Clone this projection
       ///
       /// @return New wrapped pointer to object of this class
      virtual std::unique_ptr<Rivet::Projection> clone() const {
        return std::unique_ptr<Projection>(new V0AndTrigger(*this));
      }

    };


    /// @brief Standard ALICE primary particle definition
    ///
    /// Primary particle definition according to public note
    /// <a href="https://cds.cern.ch/record/2270008">ALICE-PUBLIC-2017-005</a>
    ///
    /// @ingroup alice_rivet
    class PrimaryParticles : public Rivet::PrimaryParticles {
    public:

      PrimaryParticles(const Cut& c=Cuts::open())
        : Rivet::PrimaryParticles({},c)
      { }

       /// Compare to projections.
       ///
       /// @param p Projection to compare to.
       ///
       /// @return true (EQUIVALENT) if the projection @a p is of the same
       /// type as this, if the cuts are equal, and that the list of PDG
       /// IDs are the same.
      virtual CmpState compare(const Projection& p) const {
	const PrimaryParticles* o = dynamic_cast<const PrimaryParticles*>(&p);
	if (_cuts != o->_cuts) return CmpState::NEQ;
	return mkPCmp(*o,"PrimaryParticles");
      }

      /// Clone this projection
      virtual std::unique_ptr<Rivet::Projection> clone() const {
        return std::unique_ptr<Projection>(new PrimaryParticles(*this));
      }

    protected:

       /// Check PDG ID of particle @a p is in the list of accepted
       /// primaries.
       ///
       /// @param p Particle to investigate.
       ///
       /// @return true if the particle PDG ID is in the list of known
       /// primary PDG IDs.
       ///
       /// @note We explicitly override this to allow for nuclei, and we
       /// explicitly check for a specific set of particles (and
       /// anti-particles).  This means we do not use the base class
       /// list of particles.  Therefore, we also need to override the
       /// compare method.
       bool isPrimaryPID(ConstGenParticlePtr p) const {
        const int pdg = abs(p->pdg_id());
        // Check for nucleus
        if (pdg > 1000000000) return true;

        switch (pdg) {
        case Rivet::PID::MUON:
        case Rivet::PID::ELECTRON:
        case Rivet::PID::GAMMA:
        case Rivet::PID::PIPLUS:
        case Rivet::PID::KPLUS:
        case Rivet::PID::K0S:
        case Rivet::PID::K0L:
        case Rivet::PID::PROTON:
        case Rivet::PID::NEUTRON:
        case Rivet::PID::LAMBDA:
        case Rivet::PID::SIGMAMINUS:
        case Rivet::PID::SIGMAPLUS:
        case Rivet::PID::XIMINUS:
        case Rivet::PID::XI0:
        case Rivet::PID::OMEGAMINUS:
        case Rivet::PID::NU_E:
        case Rivet::PID::NU_MU:
        case Rivet::PID::NU_TAU:
          return true;
        }
        return false;
      }

    };


  }
}

#endif
