function writeVTKdata(Geo, Result, Mat, Set, ufile, tfile)
    [~, top_idx] = ext_z(0, Geo);

    d = load(ufile);
    u = Result.u;
    ux = d(:,3);
    uy = d(:,4);
    ux = reshape(ux, [Geo.ns(1), Geo.ns(2)]);
    uy = reshape(uy, [Geo.ns(1), Geo.ns(2)]);
    u = Result.u;
    u(top_idx, 1) = vec_nvec(ux);
    u(top_idx, 2) = vec_nvec(uy);

    t = load(tfile);
    tx = t(:,1)+t(:,3);
    ty = t(:,2)+t(:,4);
    tx = reshape(tx, [Geo.ns(1), Geo.ns(2)]);
    ty = reshape(ty, [Geo.ns(1), Geo.ns(2)]);
    Result.t(top_idx, 1) = vec_nvec(tx);
    Result.t(top_idx, 2) = vec_nvec(ty);
    writeVTK(Geo.X, u, Geo, Result, Mat, Set, sprintf("output/agata_data.vtk"))
end