function Ep = FKelvinEp(ca, cb, a, b, w)
    Ep = ca.*w.^(a)*cos(a*pi/2) + cb.*w.^(b)*cos(b*pi/2);
end