function Ep = MaxwellEp2M(K1,K2,K3,eta2,eta3,x)
    normct = 1;
    l2 = K2*x.^2./(K2^2/eta2^2+x.^2);
    l3 = K3*x.^2./(K3^2/eta3^2+x.^2);
    Ep = K1+l2+l3;
    Ep=Ep/normct;
end