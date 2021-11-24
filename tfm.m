function [Geo, Mat, Set] = tfm(Geo, Mat, Set)
    gel_height = 107.75;
    %     settings.H = 1.0775e-04; %height of the hydrogel in meter from
    %     PIM's explist

    Geo.ns = 3;
    Geo.ds = [16 16 gel_height/(Geo.ns-1)];

    Geo.u   = 'data/AGATA_TEST/Displacements/GelDisp_Cy5_beads_1.dat';
    
    Mat.type  = 'hookean';
    Mat.E = 12000; % In Pa
    Mat.nu = 0.49;

    Set.n_steps = 1;

    Set.newton_tol = 1e-4;
end
