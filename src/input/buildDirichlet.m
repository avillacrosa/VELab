function [u, dof, fix] = buildDirichlet(Geo, Set)    
	% Flow of displacement boundary conditions works as follow:
	% - If Geo.u is empty, try to read from Geo.uBC
	% - If Set.TFM is not empty, read displacement from files and apply
	%   Geo.uBC built from TFM
	% - If Geo.u is a file name, assume it contains displacements for every
	%   node.
	% In any case, Geo.uBC is assumed to be valid for all times.
	% What's left to be considered is time!
	fix = zeros(Geo.n_nodes, Geo.dim);
	z = (Geo.ns(3)-1)*Geo.ds(3);
	uBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 z 3 0];
	[fixBC, fix_vals] = BCtoNodal(Geo, uBC);
	if isfield(Geo, 'u')
		if strcmpi(Geo.u, 'random')
			% Geo.u equals to random
			u = randTFM(Geo, max(Geo.ds)/32);
			[~, top_idx2] = ext_z(0, Geo);
			fix(top_idx2,:) = true;
		elseif strcmpi(Geo.u, 'harmonic')
			u = harmTFM(Geo, Set);
			[~, top_idx2] = ext_z(0, Geo);
			fix(top_idx2,:) = true;
		else
			u = load(Geo.u);
        	u = u.u;
		end
		% TODO FIXME Either MATLAB sucks at handling 3D arrays or I suck
		% and I dont know of a way to do this
	end
	for tk = 1:Set.time_incr
		ut = u(:,:,tk);
		ut(fixBC) = fix_vals(fixBC);
		u(:,:,tk) = ut;
	end
	fix = fix | fixBC;
	dof = not(fix);
end


