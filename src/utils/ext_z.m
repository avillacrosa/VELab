function [zl_idx, zl_idx_l] = ext_z(zl, Geo)
    nx = Geo.ns(1);
    ny = Geo.ns(2);
    nz = Geo.ns(3)-zl;

    nstart = nx*ny*nz-nx*ny+1;
    nend   = nx*ny*nz;
    zl_idx_l = nstart:3:nend;
    zl_idx = (Geo.dim*(nstart-1)+1):3:Geo.dim*nend;
    zl_idx = sort(cat(2, zl_idx, zl_idx+1));
end