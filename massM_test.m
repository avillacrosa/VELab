function [Geo, Mat, Set] = massM_test(Geo, Mat, Set)
    %% Geometry parameters
    nn = 3;
    Geo.ns = [nn nn 2];
    Geo.ds = [1/2  1/2 1];
    
    Geo.dBC = [3 0 2 0; 3 0 1 0; 3 0 3 0  ; 3 1 3 0];
    Geo.fBC = 'random';
    
    %% Material parameters
    Mat.type  = 'neohookean';
    Mat.P     = [57.6923 38.4615]; %Corresponding to E = 100 and nu = 0.3
    
    %% Numerical settings
    Set.n_steps = 1;
    Set.TFM  = true;
    Set.output = 'tfm';
end