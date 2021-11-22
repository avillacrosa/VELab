function [Geo, Mat, Set] = tfm(Geo, Mat, Set)
    nn = 10;
    dn = nn-1;
    Geo.ns = 3;
    Geo.ds = [1/dn 1/dn 1/8];
    
    Geo.uBC = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 (nn-1)*dn 3 0];
    Geo.u   = 'data/AGATA_TEST/Displacements/GelDisp_Cy5_beads_1.dat';
    
    Mat.type  = 'hookean';
    Mat.P     = [57.6923 38.4615]; 

    Set.n_steps = 1;
end