function [Et, Ep, Epp] = kelvin(Mat, t)
    Ep = ca.*w.^(a)*cos(a*pi/2) + cb.*w.^(b)*cos(b*pi/2);
    Epp = ca.*w.^(a)*sin(a*pi/2) + cb.*w.^(b)*sin(b*pi/2);
    Et = ca*t.^(-a)./gamma(1-a) + cb*t.^(-b)./gamma(1-b);
end