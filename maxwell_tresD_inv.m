function [Geo, Mat, Set] = maxwell_tresD_inv(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = 3;
    Geo.ds = [  1   1   1/2];
    Geo.u  = 'output/u_maxwell_tresD.mat';

    %% Material parameters
    Mat.type  = 'hookean';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    Mat.visco  = 1;
    Mat.rheo = 'invmaxwell';

    Set.n_steps = 1;
    Set.time_incr = 5;
    Set.n_saves   = 5;
end