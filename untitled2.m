agata_data = load('data/AGATA_TEST/Displacements/GelDisp_Cy5_beads_1.dat');
tract_data = load('data/AGATA_TEST/Tractions/Traction_filteredCy5_beads_1.dat');
Geo.ns = [93    93     3];
Geo.ds = [16.0000   16.0000   53.8750];
Geo.dim = 3;

[~, top_idx] = ext_z(0, Geo);
[X, n, na] = meshgen(Geo.ns, Geo.ds);
X = X(top_idx,[1,2]);
XA = [agata_data(:,1), agata_data(:,2)];
% vals = sqrt(agata_data(:,3).*agata_data(:,3) + agata_data(:,4).*agata_data(:,4));
tx = tract_data(:,1)+tract_data(:,3);
ty = tract_data(:,2)+tract_data(:,4);
vals = sqrt(agata_data(:,3).*agata_data(:,3) + agata_data(:,4).*agata_data(:,4));
% vals = sqrt(tx.*tx + ty.*ty);
ut = [agata_data(:,3), agata_data(:,4)];


XXA = reshape(XA(:,1), [93, 93]);
XYA = reshape(XA(:,2), [93, 93]);

XX = reshape(X(:,1), [93, 93]);
XY = reshape(X(:,2), [93, 93]);

vals = reshape(vals, [93, 93]);
valsmy = vals';

figure
surf(XX, XY, valsmy)
title('MINE');
view(2);

figure
surf(XXA, XYA, vals)
title('AGATA');
view(2);