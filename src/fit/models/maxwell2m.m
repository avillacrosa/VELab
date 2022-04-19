function [Et, Ep, Epp] = maxwell2m(K1,K2,K3,eta2,eta3,x)
    l2 = K2*x.^2./(K2^2/eta2^2+x.^2);
    l3 = K3*x.^2./(K3^2/eta3^2+x.^2);
    Ep = K1+l2+l3;
    Ep=Ep/normct;
    l2 = (K2^2*x/eta2)./(K2^2/eta2^2+x.^2);
    l3 = (K3^2*x/eta3)./(K3^2/eta3^2+x.^2);
    Epp = l2 + l3;
    Epp=Epp/normct;
	Et = K1+K2*exp(-K2*x/eta2)+K3*exp(-K3*x/eta3);
end
