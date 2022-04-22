function [Geo, Mat, Set] = mx_harm(Geo, Mat, Set)
    %% Geometry parameters
    % Number of nodes in each direction
    nn = 5;
    dn = 1/(nn-1);
    Geo.ns = [nn nn nn];
    Geo.ds = [dn dn dn/5];

    Geo.u = 'harmonic';
	Geo.w = 500;
    
    %% Material parameters
    % Possible types = hookean, neohookean, venant
    Mat.type  = 'hookean'; % Merge these two?
    Mat.rheo  = 'maxwell'; % Merge these two?
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
	Set.name = 'mx_harm';
end