function [Geo, Mat, Set] = kelvin_tresD_inv(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = 3;
    Geo.ds     = [  1   1   1/2];
    Geo.ufile  = 'output/u_kelvin_tresD.mat';

    %% Material parameters
    Mat.type  = 'hookean';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    Mat.visco  = 1;
    Mat.rheo = 'kelvin';

    Set.n_steps = 1;
    Set.time_incr = 10;
    Set.n_saves   = 10;
end