%--------------------------------------------------------------------------
% Obtain the derivative of the shape functions (N) with respect to the 
% deformed coordinates (x)
%--------------------------------------------------------------------------
function [dNdx, J] = getdNdx(x, z, type)
    [~, dNdz] = fshape(type, z);
    dxdz = dNdz'*x;
    dNdx = (dxdz\dNdz')';
    J    = det(dxdz);
end