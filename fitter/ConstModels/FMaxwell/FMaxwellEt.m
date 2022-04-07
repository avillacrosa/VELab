function Et = FMaxwellEt(ca, cb, a, b, t)
    zmlf = -cb*t.^(a-b)./ca;
    Et = cb*t.^(-b).*mymlf(a-b,1-b,10,zmlf);
end