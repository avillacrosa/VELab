function [Geo, Mat, Set] = fract_maxwell(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    nn = 5;
    dn = 1/(nn-1);
    Geo.ns = [nn nn nn];
    Geo.ds = [dn dn/30 dn/30];

    Geo.uBC = [1 0 1 0; 3 0 3 0; 1 1 1 1+1/100];

    % Surface forces. 
    % Cartesian plane, target plane, traction axis, traction value
    % All respective to starting coordinates (X)
    Geo.t   = 'random';
%     Geo.tBC   = [1 1 1 10];

%     Geo.ufile = 'output/u_input_data';
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.rheo  = 'fmaxwell';
    Mat.c_alpha  = 550447.04 ;
    Mat.alpha    = 0.31;
    Mat.c_beta   = 38953.95;
    Mat.beta     = 0.03;
    Mat.visco = 1;
    Mat.E     = 100;
    Mat.nu    = 0.3;
    Mat.visco = 1;
    %% Numerical settings
    Set.n_steps = 1;
    Set.time_incr = 10000;
end