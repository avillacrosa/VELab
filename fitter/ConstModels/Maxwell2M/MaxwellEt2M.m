function stress = MaxwellEt2M(K1,K2,K3,eta2,eta3,x)
    stress = K1+K2*exp(-K2*x/eta2)+K3*exp(-K3*x/eta3);
    stress = stress;
end