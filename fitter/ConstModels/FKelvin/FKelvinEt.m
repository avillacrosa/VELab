function Et = FKelvinEt(ca, cb, a, b, t)
    Et = ca*t.^(-a)./gamma(1-a) + cb*t.^(-b)./gamma(1-b);
end
