function Result = saveInfo(Geo, Mat, Set, Result)
    Result.X     = Geo.X; 
    Result.n     = Geo.n; 
    Result.dof   = Geo.dof;
    Result.fix   = Geo.fix;
    % TODO ELSE
%     if isfield(Geo, 'F') && ~isfield(Result, 'F')
%         Result.F    = ref_nvec(Geo.F, Geo.n_nodes, Geo.dim);
%     end
%     % TODO ELSE
%     if isfield(Geo, 't') && ~isfield(Result, 't')
%         Result.t    = ref_nvec(Geo.t, Geo.n_nodes, Geo.dim);
%     end
    Result.T    = ref_nvec(internalF(Result.x(:,:,end), Geo, Mat, Set),...
                            Geo.n_nodes, Geo.dim);     
    Result.P     = Mat.P;
    Result.visco = Mat.visco;
end