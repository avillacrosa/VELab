function F = deformF(x,X,z)
    [~, dNdz] = fshape('square',z);
    dXdz = X'*dNdz;
    dNdX = (dXdz\dNdz')';
    F     = x'*dNdX;
end