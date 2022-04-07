function Et = FZenerEt(ca, cb, cc, a, b, c, t)
    zmlf = -cb*t.^(a-b)./ca;
    Et = cb*t.^(-b).*mymlf(a-b,1-b,10,zmlf) + cc*t.^(-c)./gamma(1-c);
end