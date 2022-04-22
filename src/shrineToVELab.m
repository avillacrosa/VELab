function [Geo, Mat, Set] = shrineToVELab(e, n, p,  settings, tmax)

	% TODO
	% DO YOU WANT TO PERFORM FIT
	%	if yes
	%		nanoindentation or rheology
	%		Mat = fitted params

	Geo.x_units = 1e-6;
	gel_height = settings.H;

	Geo.ns = 3;
	Geo.ds(3) = gel_height/Geo.ns;

    allFiles = string(n.files.pivdisp);
	
	Geo.u  = fullfile(p.files.pivdisptrac{e}, allFiles(e,:));
	Mat.E  = settings.E;
	Mat.nu = settings.nu;
	% Hardcode...
	Mat.type = 'hookean';
	Mat.rheo = 'maxwell';
	Mat.visco = 10;

	Set.dt     = settings.dt;
	Set.dt_obs = Set.dt;
	Set.time_incr = tmax;
	Set.save_freq = 1;
	Set.name = 'burst_test_kelvin';
end