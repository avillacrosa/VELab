function Result = saveOutData(t, c, k, u, stress, strain, F, T, M, Geo, Mat, Set, Result)
    	[~, top_idx] = ext_z(0, Geo);
    	
        Result.time(c)       = t;
        Result.u(:,:,c)      = ref_nvec(u(:,k+1), Geo.n_nodes, Geo.dim);        
        Result.x(:,:,c)      = Geo.X + Result.u(:,:,c);
% 		Result.strain(:,:,c) = strain(:,:,k);
		Result.stress(:,:,c) = recoverNodals(stress(:,:,:,k+1), Geo, Set);
		Result.F(:,:,c)      = ref_nvec(F(:,k+1), Geo.n_nodes, Geo.dim); % This can be moved to Result definition.
		Result.T(:,:,c)      = ref_nvec(T, Geo.n_nodes, Geo.dim);
		Result.t(:,:,c)      = M \ Result.T(:,:,c);
		Result.t_top(:,:,c)  = Result.t(top_idx,:,c);
		% add tbssnsq here? 
end