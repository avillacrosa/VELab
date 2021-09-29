%--------------------------------------------------------------------------
% Obtain the deformation gradient tensor (dx/dX)
%--------------------------------------------------------------------------
function F = deformF(x,X,z, shape_type)
    [~, dNdz] = fshape(shape_type,z);
    dXdz = X'*dNdz;
    dNdX = (dXdz\dNdz')';
    F     = x'*dNdX;
end