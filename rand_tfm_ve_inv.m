function [Geo, Mat, Set] = rand_tfm_ve_inv(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    nn = 5;
    Geo.ns = [nn nn 4];
    Geo.ds = [1 1 1/3];
    Geo.u  = 'output/u_rand_tfm_ve.mat';
    Geo.dBC = [3 0 2 0; 3 0 1 0; 3 0 3 0  ; 3 1 3 0];

    %% Material parameters
    Mat.type  = 'hookean';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    Mat.visco  = 1;
    Mat.rheo = 'invkelvin';
end