function [Geo, Mat, Set] = kelvin_tresD(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = [  10   10   3];
    Geo.ds = [  1   1   1/2];

    % Initial loads
    % Cartesian plane parallel to desired plane, plane location, axis 
    % direction, boundary
    % value. Ex: 1 10 0 sets the equilibrium position of all nodes in the 
    % plane X = 10 to 0
    Geo.dBC = [1 0 1 0; 2 0 2 0; 3 0 3 0; 3 1 3 1; 1 9 1 9];
%     Geo.dBC = [1 0 1 0; 2 0 2 0];

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
    
%     Mat.P     = [0 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    
end