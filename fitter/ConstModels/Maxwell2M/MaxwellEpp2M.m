function Epp = MaxwellEpp2M(K1,K2,K3,eta2,eta3,x)
    normct = 1;
    l2 = (K2^2*x/eta2)./(K2^2/eta2^2+x.^2);
    l3 = (K3^2*x/eta3)./(K3^2/eta3^2+x.^2);
    Epp = l2 + l3;
    Epp=Epp/normct;
end