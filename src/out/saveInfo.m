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
    [~, top_idx] = ext_z(0, Geo);
    
    Result.t_top = Result.t(top_idx,:);
    
    ux = Geo.u(top_idx, 1);
    ux = reshape(ux, [Geo.ns(1), Geo.ns(2)]);
    uy = Geo.u(top_idx, 2);
    uy = reshape(uy, [Geo.ns(1), Geo.ns(2)]);
    [tx,ty] = inverseBSSNSQ(Mat.E,Mat.nu,Geo.ds(1),Geo.ds(3)*(Geo.ns(3)-1),ux,uy,1);
    Result.t_bssnsq(:,[1,2]) = [vec_nvec(tx),vec_nvec(ty)];

    Result.visco = Mat.visco;
end