function [Geo, Mat, Set] = shear_in(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [2 2 2];
    ds = [1 1 1];
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);
    % Initial loads
    % Cartesian plane parallel to desired plane, plane location, boundary
    % value. Ex: 1 10 0 sets the equilibrium position of all nodes in the 
    % plane X = 10 to 0
    Geo.x0 = [  1 1 0 
                1 2 0
                1 3 0
                2 1 0
                2 2 0 
                2 3 0 
                3 1 0
                3 2 0
                3 3 0
                4 1 0
                4 2 0
                4 3 0
                5 3 0
                6 3 0
                7 3 0 
                8 3 0  ];
    
    % Surface forces. 
    % Cartesian plane, target plane, traction axis, traction value
    % All respective to starting coordinates (X)
    Geo.fBC = [3 1 2 10];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type = 'hookean';
    
    Mat.P    = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    %% Numerical settings
    Set.newton_its = 1;
    
end