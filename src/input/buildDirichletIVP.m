function [u, fix] = buildDirichletIVP(Geo, Mat, Set)
	u = Geo.u; fix = Geo.fix;
	if Set.TFM
		u = buildDirichletTFM(Geo, Mat, Set);
		[~, top_bc_xy] = ext_z(0, Geo);
		fix(top_bc_xy,:) = true;
	elseif strcmpi(Geo.u_file, 'random')
		u = randTFM(Geo, max(Geo.ds)/32);
		[~, top_bc_xy] = ext_z(0, Geo);
		fix(top_bc_xy,:) = true;
	elseif strcmpi(Geo.u_file, 'harmonic')
		u = harmTFM(Geo, Set);
		[~, top_bc_xy] = ext_z(0, Geo);
		fix(top_bc_xy,:) = true;
	end
end