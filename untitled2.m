agata_data = load('data/AGATA_TEST/Displacements/GelDisp_Cy5_beads_1.dat');

Geo.ns = [93    93     3];
Geo.ds = [16.0000   16.0000   53.8750];
Geo.dim = 3;

[~, top_idx] = ext_z(0, Geo);
[X, n, na] = meshgen(Geo.ns, Geo.ds);
X = X(top_idx,[1,2]);
XA = [agata_data(:,1), agata_data(:,2)];
vals = agata_data(:,3);

XXA = reshape(XA(:,1), [93, 93]);
XYA = reshape(XA(:,2), [93, 93]);

XX = reshape(X(:,1), [93, 93]);
XY = reshape(X(:,2), [93, 93]);

vals(1:20)
vals = reshape(vals, [93, 93]);
vals = vals';
vals = vals(:);
vals(1:20)
return
valsmy = vals;

valsmy = valsmy';

figure
surf(XX, XY, valsmy)
title('MINE');
view(2);

figure
surf(XXA, XYA, vals)
title('AGATA');
view(2);