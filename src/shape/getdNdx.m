function [dNdx, J] = getdNdx(x, z, type)
    [~, dNdz] = fshape(type, z);
    dxdz = dNdz'*x;
    dNdx = (dxdz\dNdz')';
    J    = det(dxdz);
    
end