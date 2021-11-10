function dof = ext_z_dof(zl, Geo)
    nx = Geo.ns(1);
    ny = Geo.ns(2);
    nz = Geo.ns(3)-zl;

    nstart = nx*ny*nz-nx*ny+1;
    nend   = nx*ny*nz;
    dof = Geo.dof(Geo.dof > (Geo.dim*(nstart-1)+1));
    dof = dof(dof < Geo.dim*nend);
end