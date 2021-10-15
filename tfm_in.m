function [Geo, Mat, Set] = tfm_in(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = 2;
    Geo.ds = [1 1 1];
    Geo.u  = 'u_tfm_out.txt';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'neohookean';
    Mat.P     = [57.6923 38.4615]; % Corresponding to E = 100 and nu = 0.3

    
end