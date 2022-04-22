function [t, F] = buildNeumann(Geo, Set)
	% Flow of displacement boundary conditions works as follow:
	% - If Geo.t is empty, try to read from Geo.tBC
	% - If Set.TFM is not empty, read tractions from files 
	% - If Geo.t is a file name, assume it contains tractions for every
	%   node.
	% In any case, Geo.uBC is assumed to be valid for all times.
	% What's left to be considered is time!
    t = zeros(Geo.n_nodes, Geo.dim, Set.time_incr);
	if isfield(Geo, 't')
		if strcmpi(Geo.t, 'random')
            t = randTFM(Geo, 15);
		else
            tstr = load(Geo.t);
            t = tstr.tr;
		end
	else
		[fix, fix_vals] = BCtoNodal(Geo, Geo.tBC);
		for tk = 1:Set.time_incr
			tt = t(:,:,tk);
			tt(fix) = fix_vals(fix);
			t(:,:,tk) = tt;
		end
	end
	M = areaMassLI(Geo.X, Geo, Set);
	F = zeros(size(t));
	for k = 1:Set.time_incr
		F(:,:,k) = M * t(:,:,k);
	end
end

