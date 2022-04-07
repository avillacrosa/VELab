function [Geo, Mat, Set] = upy_relax(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    nn = 5;
    dn = 1/(nn-1);
    Geo.ns = [2*nn nn nn];
    Geo.ds = [dn/2 dn/10 dn/10];

    Geo.uBC = [1 0 1 0; 1 0 2 0; 1 0 3 0; 
               2 0 2 0; 2 0 3 0; 
               3 0 2 0; 3 0 3 0; 
               2 0.1 2 0; 2 0.1 3 0; 
               3 0.1 2 0; 3 0.1 3 0; 
               1 1.1250 1 0.00125];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.rheo  = 'fmaxwell';
    Mat.c_alpha  = 229325.50;
    Mat.alpha    = 0.22;
    Mat.c_beta   = 42563.46;
    Mat.beta     = 0.02;
    Mat.E     = 100;
    Mat.nu    = 0.3;
    Mat.visco = 1;
    %% Numerical settings
    Set.n_steps = 1;
	dt = 0.1;
    Set.time_incr = 600/dt;
	Set.save_freq = 100/dt;
	Set.dt = dt;
end