function [u, dof, fix] = buildDirichletTFM(Geo, Set)    
	% Flow of displacement boundary conditions works as follow:
	% - If Geo.u is empty, try to read from Geo.uBC
	% - If Set.TFM is not empty, read displacement from files and apply
	%   Geo.uBC built from TFM
	% - If Geo.u is a file name, assume it contains displacements for every
	%   node.
	% In any case, Geo.uBC is assumed to be valid for all times.
	% What's left to be considered is time!
    u = zeros(Geo.n_nodes, Geo.dim, Set.time_incr);

	z = (Geo.ns(3)-1)*Geo.ds(3);
	uBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 z 3 0];
	[fix, fix_vals] = BCtoNodal(Geo, uBC);

	if size(Geo.u,2) ~= 1
		for t = 1:Set.time_incr
			udata_t = load(Geo.u(t));
			% TODO, there has to be a cleaner way for this no?
			ux_t = vec_to_grid(udata_t(:,3), Geo); ux_t = ux_t';
			ux_t = grid_to_vec(ux_t);
			ux_t(isnan(ux_t)) = 0;
			uy_t = vec_to_grid(udata_t(:,4), Geo); uy_t = uy_t';
			uy_t = grid_to_vec(uy_t);
			uy_t(isnan(uy_t)) = 0;
			[top_idx1, top_idx2] = ext_z(0, Geo);
			u(top_idx2,[1,2],t) = [ux_t, uy_t];

			ut = u(:,:,t);
			ut(fix) = fix_vals(fix);
			u(:,:,t) = ut;
		end
		fix(top_idx2,:) = true;
	elseif isfile(Geo.u)
		% TODO
	end
	dof = not(fix);
end


