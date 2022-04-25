function u = harmTFM(Geo, Set)
    u = zeros(Geo.n_nodes, Geo.dim, Set.time_incr);
	[~, top_idx2] = ext_z(0, Geo);

	xtop = Geo.X(top_idx2,[1,2]);
	r0 = mean(xtop);

	xtop  = xtop-r0;
	ths = atan2(xtop(:,2),xtop(:,1));
	rpl = vecnorm(xtop, 2, 2);
	for k = 1:Set.time_incr
		gamma = 0.1*sin(Geo.w*k*Set.dt);
		u(top_idx2,1,k) = rpl.*cos(ths+gamma)-xtop(:,1);
		u(top_idx2,2,k) = rpl.*sin(ths+gamma)-xtop(:,2);
	end
end