function [Et, Ep, Epp] = fzener(ca, cb, cc, a, b, c, w)
	Ep = (cb*w.^b).^2.*ca.*w.^a.*cos(a*pi/2)+(ca*w.^a).^2.*cb.*w.^b.*cos(b*pi/2);
    div = (ca*w.^a).^2+(cb*w.^b).^2+2.*ca.*w.^a.*cb.*w.^b.*cos((a-b)*pi/2);

	Epp = (cb.*w.^b).^2.*ca.*w.^a.*sin(a*pi/2)+(ca.*w.^a).^2.*cb.*w.^b.*sin(b*pi/2);
    Epp = Epp./div + cc.*w.^(c)*sin(c*pi/2);
    Ep = Ep./div + cc.*w.^(c)*cos(c*pi/2);
	zmlf = -cb*t.^(a-b)./ca;
    Et = cb*t.^(-b).*mlf(a-b,1-b,10,zmlf) + cc*t.^(-c)./gamma(1-c);
end