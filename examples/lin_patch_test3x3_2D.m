function [Geo, Mat, Set] = lin_patch_test3x3_2D()
    Geo = struct();
    Mat = struct();
    Set = struct();
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [4 4 1];
    ds = [1 1 1]/3;
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);
    
    % Initial loads
    % Node, Axis (X=1, Y=2, Z=3), Value
    Geo.f = [
        4  1 10
        8  1 10 
        12 1 10
        16 1 10 
        ];
    
    Geo.x0 = [
        1 1 0
        1 2 0
        2 2 0
        3 2 0
        4 2 0
        5 1 0 
        9 1 0
        13 1 0
        ];
    
    %% Material parameters
    % Possible types = hookean, neohookean
    Mat.type = 'hookean';
    
    Mat.P    = [57.6923 38.4615];
    
    %% Numerical settings
    % Problem type
    Set.type = 'linear';
    
end