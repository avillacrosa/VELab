% function [Geo, Mat, Set] = shrineToVELab(e, n, p,  settings, tmax)
function [Geo, Mat, Set] = shrineToVELab(dt, E, nu, d, h, ux, uy, settings_ve)
	Geo.ns        = 3;
	Geo.ds([1,2]) = d;
	Geo.ds(3)     = h/Geo.ns;

	Geo.u  = [ux; uy];
	Mat.E  = E;
	Mat.nu = nu;

	Mat.type = 'hookean';
	Mat.rheo = 'maxwell';
	Mat.visco = 10;

	Set.dt     = dt;
	Set.dt_obs = Set.dt;
	
	Set.time_incr = tmax;
	Set.save_freq = 1;
	
	Set.output = 'none';
end