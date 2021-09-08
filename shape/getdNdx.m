function [dNdx, J] = getdNdx(type, x, z)
    [~, dNdz] = fshape(type, z);
    dxdz = dNdz'*x;
    dNdx = (dxdz\dNdz')';
    J    = det(dxdz);
end