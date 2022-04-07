function Ep = FZenerEp(ca, cb, cc, a, b, c, w)
    Ep = (cb*w.^b).^2.*ca.*w.^a.*cos(a*pi/2)+(ca*w.^a).^2.*cb.*w.^b.*cos(b*pi/2);
    div = (ca*w.^a).^2+(cb*w.^b).^2+2.*ca.*w.^a.*cb.*w.^b.*cos((a-b)*pi/2);
    Ep = Ep./div + cc.*w.^(c)*cos(c*pi/2);
end