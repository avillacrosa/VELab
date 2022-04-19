function [Ep, Epp] = fkelvin_w(ca, cb, a, b, w)
    Ep = ca.*w.^(a)*cos(a*pi/2) + cb.*w.^(b)*cos(b*pi/2);
    Epp = ca.*w.^(a)*sin(a*pi/2) + cb.*w.^(b)*sin(b*pi/2);
end