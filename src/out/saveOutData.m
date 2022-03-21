function Result = saveOutData(t, c, u, stress, F, M, Geo, Mat, Set, Result)
        Result.times(c+1)      = t;
        Result.u(:,:,c+1)      = ref_nvec(u(:,2), Geo.n_nodes, Geo.dim);        
        Result.x(:,:,c+1)      = Geo.X + Result.u(:,:,c+1);
        Result.stress(:,:,c+1) = stress(:,:,end);
        Result.F(:,:,c+1)      = F;
        Result.t(:,:,c+1)      = M \ Result.F(:,:,c+1);
end