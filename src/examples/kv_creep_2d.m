function [Geo, Mat, Set] = kv_creep_2d(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = [5 5 1];
    Geo.ds = [1 1 1]/4;

    Geo.uBC = [1 0 1 0; 2 0 2 0;];
    Geo.tBC = [1 1 1 10];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean'; % Merge these two?
    Mat.rheo  = 'kelvin'; % Merge these two?
    Mat.E     = 100;
    Mat.nu    = 0; % No off diagonal terms in D matrix
    Mat.visco = 1;

    %% Numerical settings
    Set.n_steps = 1;
    Set.time_incr = 2000;
    Set.save_freq = 50;
	Set.calc_stress = true;
	Set.calc_strain = true;

	Set.plot_stress = false;
	Set.plot_strain = true;
end