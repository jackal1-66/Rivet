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
      book(_h_D0,1, 1, 1);                                      // production cross section of D0 meson
      book(_h_Dplus,2, 1, 1);                                   // production cross section of Dplus meson
      book(_h_Dstar,3, 1, 1);                                   // production cross section of Dstar meson
      book(_h_Ds,4, 1, 1);                                      // production cross section of Ds meson
      book(_h_DplusonD0,5, 1, 1);                               // ratio of production cross section between Dplus and D0
      book(_h_DstaronD0,6, 1, 1);                               // ratio of production cross section between Dstar and D0
      book(_h_DsonD0,7, 1, 1);                                  // ratio of production cross section between Ds and D0
      book(_h_DsonDplus,8, 1, 1);                               // ratio of production cross section between Ds and Dplus
      book(_h_D0int,9,1,1);                                     // pt-integrated production cross section of D0 meson
      book(_h_Dplusint,10,1,1);                                 // pt-integrated production cross section of Dplus meson
      book(_h_Dstarint,11,1,1);                                 // pt-integrated production cross section of Dstar meson
      book(_h_Dsint,12,1,1);                                    // pt-integrated production cross section of Ds meson
      book(_h_cc,13,1,1);                                       // integrated cross section of ccbar
      book(_h_ptd0,14,1,1);                                     // mean pt of prompt D0
      book(_h_D0full,15,1,1);                                   // integrated cross section for D0 in full rapidity
      book(_h_ccfull,16,1,1);                                   // integrated cross section for ccbar in full rapidity
      book(_h_wei,"_h_wei",1,6999.5,7000.5, "Weight dummy");    // histogram used to calculate D0 mean pt (necessary to store an integer number for event normalisation, i.e. to still be able to compute <pT> from multiple parallel MC jobs)
      book(_h_D0dummy,"TMP/_h_D0dummy",refData(5,1,1));         // used to make DplusonD0
      book(_h_D0dummy1,"TMP/_h_D0dummy1",refData(7,1,1));       // used to make DsonD0
      book(_h_Dplusdummy,"TMP/_h_Dplusdummy",refData(8,1,1));   // used to make DsonDplus
    }


    /// Perform the per-event analysis
    /*PDG code IDs used inside the foreach cycle: 421 = D0, 411 = D+, 413 = D*+, 431 = Ds+ */
    void analyze(const Event& event) {
        const UnstableParticles& ufs = apply<UnstableParticles>(event, "UFS");
        
        foreach (const Particle& p, ufs.particles()) {
          if(p.abspid() == 421){
              if(not p.fromBottom()){
                  _h_D0full         ->fill(7.000000e+03/GeV);    
                  _h_ccfull         ->fill(7.000000e+03/GeV);}
          }
          if(p.absrap() < 0.5){
            if(p.fromBottom())
                continue;
            else
                {    
                if(p.abspid() == 421){
                    _h_D0           ->fill(p.pT()/GeV); 
                    _h_D0dummy      ->fill(p.pT()/GeV);
                    _h_D0dummy1     ->fill(p.pT()/GeV);
                    _h_D0int        ->fill(7.000000e+03/GeV);
                    _h_cc           ->fill(7.000000e+03/GeV);
                    _h_ptd0         ->fill(7.000000e+03/GeV,p.pT()/GeV);
                    _h_wei          ->fill(7.000000e+03/GeV);
                    }
                else if(p.abspid() == 411){
                    _h_Dplus        ->fill(p.pT()/GeV);
                    _h_Dplusdummy   ->fill(p.pT()/GeV);
                    _h_Dplusint     ->fill(7.000000e+03/GeV); 
                    }
                else if(p.abspid() == 413){
                    _h_Dstar        ->fill(p.pT()/GeV); 
                    _h_Dstarint     ->fill(7.000000e+03/GeV);    
                    }
                else if(p.abspid() == 431){
                    _h_Ds           ->fill(p.pT()/GeV);
                    _h_Dsint        ->fill(7.000000e+03/GeV); 
                }    
                }
        }
        }  
    }            

    /// Normalise histograms etc., after the run
    void finalize() {

      //normalize(_h_YYYY); // normalize to unity
      //all the histograms are divided by 2 since at this point the results consider both particles and antiparticles
      scale(_h_D0,          crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dplus,       crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dstar,       crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Ds,          crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_D0dummy,     crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_D0dummy1,    crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dplusdummy,  crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      
      divide(_h_Dplus,  _h_D0dummy,     _h_DplusonD0); //ratio plots
      divide(_h_Dstar,  _h_D0dummy,     _h_DstaronD0);
      divide(_h_Ds,     _h_D0dummy1,    _h_DsonD0);
      divide(_h_Ds,     _h_Dplusdummy,  _h_DsonDplus);
      
      scale(_h_D0int,       crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dplusint,    crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dstarint,    crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      scale(_h_Dsint,       crossSection()/(microbarn*2*sumOfWeights())); // norm to cross section
      
      scale(_h_cc,          1.034*crossSection()/(microbarn*2*sumOfWeights()*0.542)); 
            // 0.542 accounts for the fraction of charm quarks hadronizing into D0 mesons, the ALICE uncertainty on such a factor (0.542 ± 0.024) is not propagated here.
            // 1.034 is used to include the correction of the different shapes of the rapidity distributions of D0 and ccbar, the ALICE uncertainty on such a factor (1.034 ± 0.015, i.e. 1.5 percentage point of uncertainty) is not propagated here.
      
      scale(_h_ptd0,        1/_h_wei->bin(0).area()); //bin(0).area() returns the number of events used to calculate the mean pT
      
      scale(_h_D0full,      crossSection()/(millibarn*2*sumOfWeights())); 
            // NOTE : for the ALICE data, the y extrapolation from |y|<0.5 to full-y phase space is done with an FONLL-based factor (8.56 +2.51 -0.42). Here in MC we simply use direct MC outcome over full y.
      
      scale(_h_ccfull,      1.034*crossSection()/(millibarn*2*sumOfWeights()*0.542)); 
            // 0.542 accounts for the fraction of charm quarks hadronizing into D0 mesons, the ALICE uncertainty on such a factor (0.542 ± 0.024) is not propagated here.
            // 1.034 is used to include the correction of the different shapes of the rapidity distributions of D0 and ccbar, the ALICE uncertainty on such a factor (1.034 ± 0.016, i.e. 1.5 percentage point of uncertainty) is not propagated here.
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
