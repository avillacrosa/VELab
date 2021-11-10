function m = getdxdz(x, z, type)
    [~, dNdz] = fshape(type, z);
    m = dNdz'*x;
end