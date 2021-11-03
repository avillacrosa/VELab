function [Geo, Mat, Set] = tfm_inv(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = 4;
    Geo.ds = [1 1 1/3];
    Geo.u  = 'out/u_tfm_out.mat';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'neohookean';
    Mat.P     = [57.6923 38.4615]; % Corresponding to E = 100 and nu = 0.3
    
    Set.n_steps = 1;
end