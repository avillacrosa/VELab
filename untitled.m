agata_data = load('data/AGATA_TEST/Displacements/GelDisp_Cy5_beads_1.dat');

Geo.ns = [93    93     3];
Geo.ds = [16.0000   16.0000   53.8750];
Geo.dim = 3;

[~, top_idx] = ext_z(0, Geo);
[X, n, na] = meshgen(Geo.ns, Geo.ds);
X = X(top_idx,[1,2]);
hers = [agata_data(:,3), agata_data(:,4)];
plot()