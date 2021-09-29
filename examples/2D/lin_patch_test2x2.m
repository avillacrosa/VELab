function [Geo, Mat, Set] = lin_patch_test2x2()
    Geo = struct();
    Mat = struct();
    Set = struct();
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [3 3 1];
    ds = [0.5 0.5 1];
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);
    
    % Initial loads
    % Node, Axis (X=1, Y=2, Z=3), Value
    Geo.f = [
        3  1 10
        6  1 10 
        9  1 10
        ];
    
    Geo.x0 = [
        1 1 0
        1 2 0
        2 2 0
        3 2 0
        4 1 0 
        7 1 0
        ];
    
    %% Material parameters
    % Possible types = hookean, neohookean
    Mat.type = 'hookean';
    
    Mat.P    = [57.6923 38.4615];
    
    %% Numerical settings
    % Problem type
    Set.type = 'linear';
    
end