function writeVTKdata(Geo, Result, Mat, Set, ufile, tfile)
    [~, top_idx] = ext_z(0, Geo);

%     d = load(ufile);
%     Xtop = d(:,[1,2]);
%     utop = d(:,[3,4]);
%     u = Result.u;
%     x = Result.x;
%     Geo.X(top_idx, [1,2]) = Xtop;
%     u(top_idx, [1,2]) = utop;
%     x(top_idx, [1,2]) = Geo.X(top_idx, [1,2]) + utop;

    t = load(tfile);
    tx = t(:,1)+t(:,3);
    ty = t(:,2)+t(:,4);
    Result.t(top_idx, 1) = tx;
    Result.t(top_idx, 2) = ty;
    writeVTK(Geo.X, Result.u, Geo, Result, Mat, Set, sprintf("output/agata_data.vtk"))
end