%--------------------------------------------------------------------------
% Linear inverse problem...
%--------------------------------------------------------------------------
function Result = inv_lin(Geo, Mat, Set, Result)
%     K = stiffK(Geo,Mat,Set);
    K = stiffKSparse(Geo,Mat,Set);

    fix = Geo.fix;
    dof = Geo.dof;
    
    u = vec_nvec(Geo.u);
    
    t_b = zeros(size(Geo.f));
    t_f = zeros(size(Geo.f));
    
    t_b(Geo.fix) = K(fix,fix)*u(fix) + K(fix,dof)*u(dof);
    t_f(Geo.dof) = K(dof,fix)*u(fix) + K(dof,dof)*u(dof);
    
    Result.T = ref_nvec(t_b, Geo.n_nodes, Geo.dim);
    Result.F = ref_nvec(t_f, Geo.n_nodes, Geo.dim);
    
    Result.u = Geo.u;
end