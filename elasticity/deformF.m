function F = deformF(x,X,z)
    [~, dNdz] = fshape(type,z);
    dXdz = X'*dNdz;
    dNdX = (dXdz\dNdz')';
    F     = x'*dNdX;
end