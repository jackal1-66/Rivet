// -*- C++ -*-
#include "Rivet/Analysis.hh"
#include "Rivet/Projections/UnstableParticles.hh"

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
      declare(UnstableParticles(), "UFS");

      // Book histograms
      _h_D0         = bookHisto1D(1, 1, 1);                                   //production cross section of D0 meson
      _h_Dplus      = bookHisto1D(2, 1, 1);                                   //production cross section of Dplus meson
      _h_Dstar      = bookHisto1D(3, 1, 1);                                   //production cross section of Dstar meson
      _h_Ds         = bookHisto1D(4, 1, 1);                                   //production cross section of Ds meson
      _h_DplusonD0  = bookScatter2D(5, 1, 1);                                 //ratio of production cross section between Dplus and D0
      _h_DstaronD0  = bookScatter2D(6, 1, 1);                                 //ratio of production cross section between Dstar and D0
      _h_DsonD0     = bookScatter2D(7, 1, 1);                                 //ratio of production cross section between Ds and D0
      _h_DsonDplus  = bookScatter2D(8, 1, 1);                                 //ratio of production cross section between Ds and Dplus
      _h_D0int      = bookHisto1D(9,1,1);                                     //pt-integrated production cross section of D0 meson
      _h_Dplusint   = bookHisto1D(10,1,1);                                    //pt-integrated production cross section of Dplus meson
      _h_Dstarint   = bookHisto1D(11,1,1);                                    //pt-integrated production cross section of Dstar meson
      _h_Dsint      = bookHisto1D(12,1,1);                                    //pt-integrated production cross section of Ds meson
      _h_cc         = bookHisto1D(13,1,1);                                    //integrated cross section of ccbar
      _h_ptd0       = bookHisto1D(14,1,1);                                    //mean pt of prompt D0
      _h_D0full     = bookHisto1D(15,1,1);                                    //integrated cross section for D0 in full rapidity
      _h_ccfull     = bookHisto1D(16,1,1);                                    //integrated cross section for ccbar in full rapidity
      _h_wei        = bookHisto1D("_h_wei",1,6999.5,7000.5, "Weight dummy");  //histograms used to calculate D0 mean pt
      _h_D0dummy    = bookHisto1D("TMP/_h_D0dummy", refData(5,1,1));          //used to make DplusonD0
      _h_D0dummy1   = bookHisto1D("TMP/_h_D0dummy1", refData(7,1,1));         //used to make DsonD0
      _h_Dplusdummy = bookHisto1D("TMP/_h_Dplusdummy", refData(8,1,1));       //used to make DsonDplus
    }


    /// Perform the per-event analysis
    /*PDG code IDs used inside the foreach cycle: 421 = D0, 411 = D+, 413 = D*+, 431 = Ds+ */
    void analyze(const Event& event) {
        const double weight = event.weight();
        const UnstableParticles& ufs = apply<UnstableParticles>(event, "UFS");
        
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
                    _h_wei->fill(7.000000e+03/GeV,weight);
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
      //all the histograms are divided by 2 since at this point the results consider both particles and antiparticles
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
      scale(_h_cc, 1.034*crossSection()/(microbarn*2*sumOfWeights()*0.542)); //0.542 (with an error of 0.024) accounts for the fraction of charm quarks hadronizing into D0 mesons, 1.034 (1.5% error) is used to include the correction of the different shapes of the rapidity distributions of D0 and ccbar 
      scale(_h_ptd0, 1/_h_wei->bin(0).area()); //bin(0).area() returns the number of events used to calculate the mean pT
      scale(_h_D0full,crossSection()/(millibarn*2*sumOfWeights()));
      scale(_h_ccfull, 1.034*crossSection()/(millibarn*2*sumOfWeights()*0.542)); //0.542 (with an error of 0.024) accounts for the fraction of charm quarks hadronizing into D0 mesons, 1.034 (1.5% error) used to include the correction of the different shapes of the rapidity distributions of D0 and ccbar
    }

    //@}


    /// @name Histograms
    //@{
    Histo1DPtr _h_D0, _h_Dplus, _h_Dstar, _h_Ds, _h_D0int, _h_Dplusint, _h_wei, _h_Dstarint, _h_Dsint, _h_cc, _h_D0full, _h_D0dummy, _h_D0dummy1, _h_Dplusdummy , _h_ccfull, _h_ptd0;
    Scatter2DPtr _h_DplusonD0, _h_DstaronD0, _h_DsonD0, _h_DsonDplus;
    //@}


  };


  // The hook for the plugin system
  DECLARE_RIVET_PLUGIN(ALICE_2017_I1511870);


}
