function u = harmonicShear(Geo, Set)
	u = zeros(Geo.n_nodes*Geo.dim, Set.time_incr);
	for t = 1:Set.time_incr
		u(topMask,:) = u0*sin()
	end
end