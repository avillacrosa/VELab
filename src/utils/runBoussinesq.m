function t_bs = runBoussinesq(Geo, Mat)
    [~, top_idx] = ext_z(0, Geo);
    ux = Geo.u(top_idx, 1);
    ux = reshape(ux, [Geo.ns(1), Geo.ns(2)]);
    uy = Geo.u(top_idx, 2);
    uy = reshape(uy, [Geo.ns(1), Geo.ns(2)]);
    [tx,ty] = inverseBSSNSQ(Mat.E,Mat.nu,Geo.ds(1),Geo.ds(3)*(Geo.ns(3)-1),ux,uy,1);
    t_bs(:,[1,2]) = [vec_nvec(tx),vec_nvec(ty)];
end