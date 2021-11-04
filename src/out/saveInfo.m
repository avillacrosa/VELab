function Result = saveInfo(Geo, Mat, Set, Result)
    Result.X     = Geo.X; 
    Result.x     = Result.X + Result.u;
    Result.n     = Geo.n; 
    Result.dof   = Geo.dof;
    Result.fix   = Geo.fix;
    % TODO ELSE
    if isfield(Geo, 'F')
        Result.F    = ref_nvec(Geo.F, Geo.n_nodes, Geo.dim);
    end
    % TODO ELSE
    if isfield(Geo, 't')
        Result.t    = ref_nvec(Geo.t, Geo.n_nodes, Geo.dim);
    end
    Result.T    = ref_nvec(internalF(Result.x, Geo, Mat, Set), Geo.n_nodes, Geo.dim);     
    Result.P     = Mat.P;
    Result.visco = Mat.visco;
    Result.meanStr = meanLinStr(Result.x, Geo, Set);
end