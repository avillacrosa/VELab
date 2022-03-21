function [Geo, Mat, Set] = kv_creep(Geo, Mat, Set)
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
               3 0.1 2 0; 3 0.1 3 0; ];
    Geo.tBC = [1 1.1250 1 20];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean';
    Mat.rheo  = 'kelvin';
    Mat.E     = 100;
    Mat.nu    = 0; % No off diagonal terms in D matrix
    Mat.visco = 1;

    %% Numerical settings
    Set.n_steps = 1;
    Set.time_incr = 100;
    Set.save_freq = Set.time_incr/10;
end