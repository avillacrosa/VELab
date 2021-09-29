function [Geo, Mat, Set] = max_patch_test1x1()
    Geo = struct();
    Mat = struct();
    Set = struct();
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [2 2 1];
    ds = [1 1 1];
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);
    
    % Initial loads
    % Node, Axis (X=1, Y=2, Z=3), Value
    Geo.f = [
        2  1 10
        4  1 10 
        ];
    
    Geo.x0 = [
        1 1 0
        1 2 0
        2 2 0 
        3 1 0
        ];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.rheo  = 'maxwell';
    Mat.visco = 1;
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    %% Numerical settings
    % Problem type
    % TODO this is unnecessary, knowing the type of material we know
    % if it's nonlinear or not!
    Set.type = 'linear';
    Set.time_incr = 5000;
    
end