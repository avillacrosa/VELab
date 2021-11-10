function [Geo, Mat, Set] = kelvin_tresD(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = [  3   3   3];
    Geo.ds = [  1   1   1/2];

    % Initial loads
    % Cartesian plane parallel to desired plane, plane location, axis 
    % direction, boundary
    % value. Ex: 1 10 0 sets the equilibrium position of all nodes in the 
    % plane X = 10 to 0
    Geo.dBC = [3 0 3 0; 3 0 2 0; 3 0 1 0; 3 1 3 0];

    % Surface forces. 
    % Cartesian plane, target plane, traction axis, traction value
    % All respective to starting coordinates (X)
    Geo.fBC = 'random';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.visco = 1;
    Mat.rheo  = 'kelvin';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    Set.n_steps = 1;
    Set.time_incr = 10;
    Set.n_saves   = 10;
    
    Set.output = 'tfm';
end