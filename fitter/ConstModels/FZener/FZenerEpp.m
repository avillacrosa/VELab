function Epp = FZenerEpp(ca, cb, cc, a, b, c, w)
    Epp = (cb.*w.^b).^2.*ca.*w.^a.*sin(a*pi/2)+(ca.*w.^a).^2.*cb.*w.^b.*sin(b*pi/2);
    div = (ca*w.^a).^2+(cb*w.^b).^2+2.*ca.*w.^a.*cb.*w.^b.*cos((a-b)*pi/2);
    Epp = Epp./div + cc.*w.^(c)*sin(c*pi/2);
end