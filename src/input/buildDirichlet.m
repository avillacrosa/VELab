function [u, dof, fix] = buildDirichlet(Geo, Set)    
	% Flow of displacement boundary conditions works as follow:
	% - If Geo.u is empty, try to read from Geo.uBC
	% - If Set.TFM is not empty, read displacement from files and apply
	%   Geo.uBC built from TFM
	% - If Geo.u is a file name, assume it contains displacements for every
	%   node.
	% In any case, Geo.uBC is assumed to be valid for all times.
	% What's left to be considered is time!
    u = zeros(Geo.n_nodes, Geo.dim, Set.time_incr);
	if Set.TFM
		udata = load(Geo.u);
		z = (Geo.ns(3)-1)*Geo.ds(3);
		uBC        = [ 3 0 1 0; 3 0 2 0; 3 0 3 0; 3 z 3 0];
		if isfield(udata, 'ux')
            ts = size(udata.ux,3);
            ux = udata.ux; uy = udata.uy;
		elseif size(udata, 2) >= 5
            ts = 1;
            ux = vec_to_grid(udata(:,3), Geo);
            % TODO FIXME at the moment, data from agata, increases
            % first in y than x. In this code the opposite is assumed,
            % so a transposition is necessary
            ux = ux'; 
            uy = vec_to_grid(udata(:,4), Geo);
            uy = uy';
		end
		for ti = 2:ts 
            uxt = grid_to_vec(ux(:,:,ti));
            uyt = grid_to_vec(uy(:,:,ti));
			tidx   = getTimeIdx(Geo,ti*Set.dt_obs);
			tidxm1 = getTimeIdx(Geo,(ti-1)*Set.dt_obs);
            u((end-Geo.ns(1)*Geo.ns(2)+1):end,[1,2], tidxm1:tidx) = [uxt, uyt];
		end
		[dof, fix, fix_vals] = BCtoNodal(Geo, uBC);
		u(fix,:) = fix_vals(fix,:);
		% TODO FIXME Either MATLAB sucks at handling 3D arrays or I suck
		% and I dont know of a way to do this
		for tk = 1:Set.time_incr
			ut = u(:,:,tk);
			ut(fix) = fix_vals(fix);
			u(:,:,tk) = ut;
		end
	elseif isfield(Geo, 'u')
		if strcmpi(Geo.u, 'random')
			% Geo.u equals to random
			u = randTFM(Geo, max(Geo.ds)/32);
		else
			u = load(Geo.u);
        	u = u.u;
		end
	else
		[dof, fix, fix_vals] = BCtoNodal(Geo, Geo.uBC);
		% TODO FIXME Either MATLAB sucks at handling 3D arrays or I suck
		% and I dont know of a way to do this
		for tk = 1:Set.time_incr
			ut = u(:,:,tk);
			ut(fix) = fix_vals(fix);
			u(:,:,tk) = ut;
		end
	end
end


