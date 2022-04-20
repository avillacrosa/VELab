function Result = saveOutData(t, c, k, u, stress, strain, F, T, M, Geo, Mat, Set, Result)
    	[~, top_idx] = ext_z(0, Geo);
    	
        Result.time(c)       = t;
        Result.u(:,:,c)      = ref_nvec(u(:,k), Geo.n_nodes, Geo.dim);        
        Result.x(:,:,c)      = Geo.X + Result.u(:,:,c);
        Result.strain(:,:,c) = strain(:,:,k);
        Result.stress(:,:,c) = stress(:,:,k);
        Result.F(:,:,c)      = ref_nvec(F(:,k), Geo.n_nodes, Geo.dim); % This can be moved to Result definition.
		Result.T(:,:,c)      = ref_nvec(T(:,k), Geo.n_nodes, Geo.dim);
        Result.t(:,:,c)      = M \ Result.T(:,:,c);
    	Result.t_top(:,:,c)  = Result.t(top_idx,:,c);
		% add tbssnsq here? 
end