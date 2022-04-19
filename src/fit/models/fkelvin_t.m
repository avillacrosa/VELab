function Et = fkelvin_t(ca, a, cb, b, t)
    Et = ca*t.^(-a)./gamma(1-a) + cb*t.^(-b)./gamma(1-b);
end