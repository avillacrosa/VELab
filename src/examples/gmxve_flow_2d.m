function [Geo, Mat, Set] = gmxve_flow_2d(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    Geo.ns = [3 3 1];
    Geo.ds = [1 1 1]/2;

    Geo.uBC = [1 0 1 0; 2 0 2 0;];
    Geo.tBC = [1 1 1 10];
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'neovenant'; % Merge these two?
    Mat.rheo  = 'maxwell'; % Merge these two?
    Mat.E     = 100;
    Mat.nu    = 0.3; % No off diagonal terms in D matrix
    Mat.visco = 0.01;

    %% Numerical settings
    Set.n_steps = 1;
    Set.time_incr = 10;
    Set.save_freq = 1;
	Set.calc_stress = true;
	Set.calc_strain = true;
	Set.plot_stress = true;
	Set.plot_strain = false;

	Set.name = 'gmx_flow_2d';
end