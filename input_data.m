function [Geo, Mat, Set] = input_data(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    ns = [2 2 1];
    ds = [1 1 1];
    
    % Nodal positions and connectivity
    [Geo.x, Geo.n] = meshgen(ns, ds);

    % Initial loads
    % Cartesian plane parallel to desired plane, plane location, boundary
    % value. Ex: 1 10 0 sets the equilibrium position of all nodes in the 
    % plane X = 10 to 0
    Geo.dBC = [1 0 0.1; 2 0 0];
%     Geo.dBC = [1 0 0; 2 0 0];
    
    % Surface forces. 
    % Cartesian plane, target plane, traction axis, traction value
    % All respective to starting coordinates (X)
    Geo.fBC = [1 1 1 10];
%     Geo.u = "utest.txt";
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type = 'hookean';
    
    Mat.P    = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    %% Numerical settings
    Set.newton_its = 1;
    Set.n_quad = 2;
    
end