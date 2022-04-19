function [Et, Ep, Epp] = fmaxwell(ca, cb, a, b, w)
    Ep = (cb*w.^b).^2.*ca.*w.^a.*cos(a*pi/2)+(ca*w.^a).^2.*cb.*w.^b.*cos(b*pi/2);
    Epp = (cb.*w.^b).^2.*ca.*w.^a.*sin(a*pi/2)+(ca.*w.^a).^2.*cb.*w.^b.*sin(b*pi/2);

    div = (ca*w.^a).^2+(cb*w.^b).^2+2.*ca.*w.^a.*cb.*w.^b.*cos((a-b)*pi/2);
	zmlf = -cb*t.^(a-b)./ca;

    Ep = Ep./div;
    Epp = Epp./div;
    Et = cb*t.^(-b).*mlf(a-b,1-b,10,zmlf);
end