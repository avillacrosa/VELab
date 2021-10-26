function [Geo, Mat, Set] = real_tfm_in(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = 2;
    Geo.ds = [512 512 256]*1e-6;
    Geo.u  = 'real_tfm_u.mat';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.P     = [57.6923 38.4615]; % Corresponding to E = 100 and nu = 0.3
end