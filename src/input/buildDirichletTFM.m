function [u, dof, fix] = buildDirichletTFM(Geo, Set)    
	% Flow of displacement boundary conditions works as follow:
	% - If Geo.u is empty, try to read from Geo.uBC
	% - If Set.TFM is not empty, read displacement from files and apply
	%   Geo.uBC built from TFM
	% - If Geo.u is a file name, assume it contains displacements for every
	%   node.
	% In any case, Geo.uBC is assumed to be valid for all times.
	% What's left to be considered is time!

	z = (Geo.ns(3)-1)*Geo.ds(3);
	uBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 z 3 0];

    u = zeros(Geo.n_nodes, Geo.dim, Set.time_incr);
	if size(Geo.u,2) ~= 1
		for t = 1:Set.time_incr
			udata_t = load(fullfile(Geo.u, Geo.uTFM(t)));
			ux_t = vec_to_grid(udata_t(:,3), Geo); ux_t = ux_t';
			uy_t = vec_to_grid(udata_t(:,4), Geo); uy_t = uy_t';
			top_idx = ext_z(0, Geo);
			u(top_idx,[1,2],t) = [ux_t, uy_t];
		end
	elseif isfile(Geo.u)
		% TODO
	end
end


