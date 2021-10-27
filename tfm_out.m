function [Geo, Mat, Set] = tfm_out(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    nn = 25;
    Geo.ns = [nn nn 4];
    Geo.ds = [1 1 1/3];
    
%     Geo.ns = [16 16 1];
%     Geo.ds = [1 1 1]/15;

    % Initial loads
    % Cartesian plane parallel to desired plane, plane location, boundary
    % value. Ex: 1 10 0 sets the equilibrium position of all nodes in the 
    % plane X = 10 to 0
    Geo.dBC = [3 0 2 0; 3 0 1 0; 3 0 3 0  ; 3 1 3 0];
            %   1 0 1 0; 2 0 2 0; 1 (nn-1) 1 0; 2 (nn-1) 2 0];

    % Surface forces. 
    % Cartesian plane, target plane, traction axis, traction value
    % All respective to starting coordinates (X)
%     Geo.fBC = [3 1 2 5];
    Geo.fBC = 'random';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'neohookean';
%     Mat.visco = 1;
%     Mat.rheo  = 'maxwell';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
%     Mat.P     = [0 38.4615]; %Corresponding to E = 100 and nu = 0.3

    
    %% Numerical settings
    Set.n_steps = 1;
    Set.output  = 'tfm';
    
end