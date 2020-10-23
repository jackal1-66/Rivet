{
    TFile * a = new TFile("all_plots.root", "READ");
    TFile * b = new TFile("RivSc.root", "RECREATE");
    TCanvas * c[2];
    c[0] = (TCanvas*)a->Get("can_pythia_ScoverD0");
    c[1] = (TCanvas*)a->Get("can_pythia_LcScoverLc");
    TGraphAsymmErrors * ase[2];
    ase[0] = (TGraphAsymmErrors*)c[0]->GetListOfPrimitives()->FindObject("gSystRatio_Sc_over_prelD0_isospinScaled");
    ase[1] = (TGraphAsymmErrors*)c[1]->GetListOfPrimitives()->FindObject("tgae_syst_ratio_average_rel_err_weights");
    b->cd();
    ase[0]->Write();
    ase[1]->Write();
    b->Close();
    a->Close();
}