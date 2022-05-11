function [u, fix] = buildDirichletBC(Geo, Mat, Set)
	u = Geo.u; fix = Geo.fix;
	[fixBC, fix_vals] = BCtoNodal(Geo, Geo.uBC);
	% TODO FIXME, this is not ideal but I could not find a work around...
	for tk = 1:Set.time_incr
		ut = u(:,:,tk);
		ut(fixBC) = fix_vals(fixBC);
		u(:,:,tk) = ut;
	end
	fix = fix | fixBC;
end