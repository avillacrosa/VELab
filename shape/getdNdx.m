function [dNdx, J] = getdNdx(type, x, z)
    [~, dNdz] = fshape(type, z);
    dxdz = x'*dNdz;
    dNdx = (dxdz\dNdz')';
    J    = det(dxdz);
end