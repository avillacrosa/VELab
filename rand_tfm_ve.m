function [Geo, Mat, Set] = rand_tfm_ve(Geo, Mat, Set)
    %% Geometry parameters
    nn = 5;
    Geo.ns = [nn nn 4];
    Geo.ds = [1 1 1/3];
    
    Geo.dBC = [3 0 2 0; 3 0 1 0; 3 0 3 0  ; 3 1 3 0];
    Geo.fBC = 'random';
    
    %% Material parameters
    Mat.type  = 'hookean';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    Mat.visco  = 1;
    Mat.rheo = 'kelvin';
    
    %% Numerical settings
    Set.n_steps = 1;
%     Set.TFM  = true;
%     Set.output = 'tfm';
    Set.time_incr = 5;
    Set.n_saves   = 5;
end