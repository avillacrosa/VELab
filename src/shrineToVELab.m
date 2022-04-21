function [Geo, Mat, Set] = shrineToVELab(e, n, p,  settings, tmax)

	% TODO
	% DO YOU WANT TO PERFORM FIT
	%	if yes
	%		nanoindentation or rheology
	%		Mat = fitted params
	gel_height = settings.H;

	Geo.ns = 5;
	Geo.ds = gel_height/Geo.ns;
    allFiles = string(n.files.pivdisp);
	Geo.u  = fullfile(p.files.pivdisptrac{e}, allFiles(e,:));
	Mat.E  = settings.E;
	Mat.nu = settings.nu;

	Set.dt     = settings.dt;
	Set.dt_obs = Set.dt;
	Set.time_incr = tmax;
	Set.save_freq = 1;
end