function [tx_t, ty_t] = shrineRunVE(dt, E, nu, d, h, ux, uy, settings_ve)
	[Geo, Mat, Set] = shrineToVELab(dt, E, nu, d, h, ux, uy, settings_ve);
	Result = runVE(Geo, Mat, Set);
	tx_t = Result.t_top(:,1,:);
	ty_t = Result.t_top(:,2,:);
end
