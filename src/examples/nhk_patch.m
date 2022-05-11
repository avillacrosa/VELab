function [Geo, Mat, Set] = nhk_patch(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = [7 7 1];
    Geo.ds = [1 1 1]/6;

    Geo.uBC = [1 0 1 0; 2 0 2 0;];
    Geo.tBC = [1 1 1 10];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'neohookean'; % Merge these two?
    Mat.E     = 100;
    Mat.nu    = 0.3; % No off diagonal terms in D matrix

    %% Numerical settings
    Set.n_steps = 1;
    Set.time_incr = 1;
    Set.save_freq = 1;
	Set.calc_stress = true;
	Set.calc_strain = true;

	Set.plot_stress = false;
	Set.plot_strain = true;
    fname = dbstack;
	Set.name = fname.name;
end