function Ep = FMaxwellEp(ca, cb, a, b, w)
    Ep = (cb*w.^b).^2.*ca.*w.^a.*cos(a*pi/2)+(ca*w.^a).^2.*cb.*w.^b.*cos(b*pi/2);
    div = (ca*w.^a).^2+(cb*w.^b).^2+2.*ca.*w.^a.*cb.*w.^b.*cos((a-b)*pi/2);
    Ep = Ep./div;
end