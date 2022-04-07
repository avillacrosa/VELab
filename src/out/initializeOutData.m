function Result = initializeOutData(Geo, Set)
	% TODO FIXME, change save_freq to total number of snapshots???
    n_saves = fix(Set.time_incr/Set.save_freq);
    
    Result.x        = zeros(Geo.n_nodes,Geo.dim, n_saves);
    Result.x(:,:,1) = Geo.X;
    Result.u        = zeros(Geo.n_nodes,Geo.dim, n_saves);
    Result.stress   = zeros(Geo.n_nodes, Geo.vect_dim, n_saves);
    Result.F        = zeros(Geo.n_nodes,Geo.dim, n_saves);
    Result.t        = zeros(Geo.n_nodes,Geo.dim, n_saves);
    
    Result.times   = zeros(1, n_saves);
end