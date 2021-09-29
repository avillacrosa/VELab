function [Geo, Mat, Set] = nh_patch_test5x5()
    Geo = struct();
    Mat = struct();
    Set = struct();
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [6 6 1];
    ds = [1 1 1]/5;
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);
    
    % Initial loads
    % Node, Axis (X=1, Y=2, Z=3), Value
    Geo.f = [
        6  1 10
        12  1 10 
        18 1 10
        24 1 10 
        30 1 10 
        36 1 10 
        ];
    
    Geo.x0 = [
        1 1 0
        1 2 0
        2 2 0
        3 2 0
        4 2 0
        5 2 0
        6 2 0
        7 1 0 
        13 1 0
        19 1 0
        25 1 0
        31 1 0
        ];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type = 'neohookean';
    
    Mat.P    = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    %% Numerical settings
    % Problem type
    % TODO this is unnecessary, knowing the type of material we know
    % if it's nonlinear or not!
    Set.type = 'nonlinear';
    
end