ux = Geo.u(top_idx, 1);
ux = reshape(ux, [Geo.ns(1), Geo.ns(2)]);
uy = Geo.u(top_idx, 2);
uy = reshape(uy, [Geo.ns(1), Geo.ns(2)]);
[tx,ty] = inverseBSSNSQ(Mat.E,Mat.nu,Geo.ds(1),Geo.ds(3)*(Geo.ns(3)-1),ux,uy,1);
xtop = Geo.X(top_idx,1);
ytop = Geo.X(top_idx,2);
xtop = reshape(xtop, [Geo.ns(1), Geo.ns(2)]);
ytop = reshape(ytop, [Geo.ns(1), Geo.ns(2)]);

%     clim = 1e0;

tbn = sqrt(tx.*tx+ty.*ty);
tbn = tx;
surf(xtop, ytop, tbn);
colorbar;
%     caxis([-clim clim])
view(2);
title("Boussinesq");

figure
tnx = reshape(Result.t_top(:,1), [Geo.ns(1), Geo.ns(2)]);
tny = reshape(Result.t_top(:,2), [Geo.ns(1), Geo.ns(2)]);
tn = sqrt(tnx.*tnx + tny.*tny);
tn = tnx;
surf(xtop, ytop, tn);
colorbar;
%     caxis([-clim clim])
title("FEM");
view(2);

figure
surf(xtop, ytop, tbn-tn);
colorbar;
%     caxis([-clim clim])
title("Boussinesq - FEM");
view(2);
mean(tbn-tn, 'all')