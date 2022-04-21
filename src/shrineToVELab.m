function [Geo, Mat, Set] = shrineToVELab(emax, n, p,  settings, tmax)

	% TODO
	% DO YOU WANT TO PERFORM FIT
	%	if yes
	%		nanoindentation or rheology
	%		Mat = fitted params
	gel_height = settings.H;

	Geo.ns = 5;
	Geo.ds = gel_height/Geo.ns;
	for e = 1:emax
		Geo.u = p.files.pivdisptrac{e};
		Geo.uTFM = n.files.pivdisp{e,:};
		Mat.E  = settings.E;
		Mat.nu = settings.nu;
	
		Set.dt     = settings.dt;
		Set.dt_obs = Set.dt;
		Set.time_incr = tmax;
    	Set.save_freq = 1;
	end
end