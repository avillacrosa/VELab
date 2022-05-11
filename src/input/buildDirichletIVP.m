function [u, fix] = buildDirichletIVP(Geo, Mat, Set)
	u = Geo.u; fix = Geo.fix;
    if strcmpi(Geo.uPR, 'random')
		u = randTFM(Geo, max(Geo.ds)/32);
		[~, top_bc_xy] = ext_z(0, Geo);
		fix(top_bc_xy,:) = true;
	elseif strcmpi(Geo.uPR, 'harmonic')
		u = harmTFM(Geo, Set);
		[~, top_bc_xy] = ext_z(0, Geo);
		fix(top_bc_xy,:) = true;
    elseif Geo.uPR
        u = Geo.uPR;
        % Do not trust MATLAB if it says find is not necessary. It is lying
        fix(find(u(:,:,1))) = true;
    end
end