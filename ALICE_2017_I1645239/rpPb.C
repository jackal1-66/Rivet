void rpPb(){
    TFile * a = new TFile("test2merge5Tpp.root");
    TFile * b = new TFile("test2mergepb.root");
    TGraphAsymmErrors * LcR = (TGraphAsymmErrors*)a->Get("/ALICE_2017_I1645239/LcR");
    TGraphAsymmErrors * LcRPb = (TGraphAsymmErrors*)b->Get("/ALICE_2017_I1645239/LcRPb");
    double * yp = LcR->GetY();
    double * ypb = LcRPb->GetY();
    double * yR = new double{3};
    double * x = LcR->GetX();
    double * xl = new double[3]{1.,1.,1.};
    double * xh = new double[3]{1.,1.,1.};
    double * yperr = new double[3];
    double * ypberr = new double[3];    
    double * yerr = new double[3];
    for(int i = 0; i<3; i++){
        yR[i] = ypb[i]/yp[i];
        yperr[i] = LcR->GetErrorY(i);
        ypberr[i] = LcRPb->GetErrorY(i);  
        yerr[i] = TMath::Sqrt(TMath::Power(ypberr[i]/yp[i],2)+TMath::Power(ypberr[i]*ypb[i]/(yp[i]*yp[i]),2))/2;
    }    
    TCanvas * c1 = new TCanvas("c1", "RpPb",200,10,700,500);
    c1->SetGrid();
    TGraphAsymmErrors * RpPb = new TGraphAsymmErrors(3, x, yR, xl, xh, yerr, yerr);
    RpPb->SetMarkerStyle(20);
    RpPb->SetMarkerColor(2);
    RpPb->SetTitle("R_{pPb} #Lambda_{c}^{+}");
    RpPb->GetXaxis()->SetTitle("p_{T} [GeV/c]");  
    RpPb->GetYaxis()->SetTitle("R_{pPb}"); 
    RpPb->Draw("APZ");
    c1->Print("RpPb.png");
}
