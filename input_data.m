function [Geo, Mat, Set] = input_data(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = [50 50 3];
    Geo.ds = [1/49 1/49 1];
    
%     Geo.ns = [16 16 1];
%     Geo.ds = [1 1 1]/15;

    % Initial loads
    % Cartesian plane parallel to desired plane, plane location, axis 
    % direction, boundary
    % value. Ex: 1 10 0 sets the equilibrium position of all nodes in the 
    % plane X = 10 to 0
%     Geo.dBC = [1 0 1 0; 2 0 2 0; 3 0 3 0];
    Geo.uBC = [1 0 1 0; 2 0 2 0; 3 0 3 0];

    % Surface forces. 
    % Cartesian plane, target plane, traction axis, traction value
    % All respective to starting coordinates (X)
    Geo.t   = 'random';
%     Geo.ufile = 'output/u_input_data';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.E     = 100;
    Mat.nu    = 0.3;
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.

    %% Numerical settings
    Set.n_steps = 1;
%     Set.time_incr = 10000;
%     Set.debug   = true;
    
end