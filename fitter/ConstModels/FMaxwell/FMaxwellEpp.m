function Epp = FMaxwellEpp(ca, cb, a, b, w)
    Epp = (cb.*w.^b).^2.*ca.*w.^a.*sin(a*pi/2)+(ca.*w.^a).^2.*cb.*w.^b.*sin(b*pi/2);
    div = (ca*w.^a).^2+(cb*w.^b).^2+2.*ca.*w.^a.*cb.*w.^b.*cos((a-b)*pi/2);
    Epp = Epp./div;
end