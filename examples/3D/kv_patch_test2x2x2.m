function [Geo, Mat, Set] = kv_patch_test2x2x2()
    Geo = struct();
    Mat = struct();
    Set = struct();
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [3 3 3];
    ds = [1 1 1];
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);

    % Initial loads
    % Node, Axis (X=1, Y=2, Z=3), Value
    Geo.f = [
        3   1 10
        6   1 10 
        9   1 10
        12  1 10
        15  1 10
        18  1 10
        21  1 10
        24  1 10
        27  1 10
        ];
    
    Geo.x0 = [
        1  1 0
        1  2 0
        1  3 0
        2  2 0
        2  3 0
        3  2 0
        3  3 0
        4  1 0
        4  3 0
        5  3 0
        6  3 0
        7  1 0
        7  3 0
        8  3 0
        9  3 0
       10  1 0
       10  2 0
       11  2 0
       12  2 0
       13  1 0
       16  1 0
       19  1 0
       19  2 0
       20  2 0
       21  2 0
       22  1 0
       25  1 0];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.rheo  = 'kelvin';
    Mat.visco = 1;
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    %% Numerical settings
    % Problem type
    % TODO this is unnecessary, knowing the type of material we know
    % if it's nonlinear or not!
    Set.type = 'linear';
    
end