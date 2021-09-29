function [Geo, Mat, Set] = lin_patch_test1x1x1()
    Geo = struct();
    Mat = struct();
    Set = struct();
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [2 2 2];
    ds = [1 1 1];
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);
    Geo.n
    % Initial loads
    % Node, Axis (X=1, Y=2, Z=3), Value
    Geo.f = [
        2  1 10
        4  1 10 
        6  1 10
        8  1 10
        ];
    
    Geo.x0 = [
        1 1 0
        1 2 0
        1 3 0
        2 2 0
        2 3 0
        3 1 0
        3 3 0
        4 3 0
        5 1 0
        5 2 0
        6 2 0
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