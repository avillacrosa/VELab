function Epp = FKelvinEpp(ca, cb, a, b, w)
    Epp = ca.*w.^(a)*sin(a*pi/2) + cb.*w.^(b)*sin(b*pi/2);
end