%--------------------------------------------------------------------------
% Linear inverse problem...
%--------------------------------------------------------------------------
function Result = inv_lin(Geo, Mat, Set, Result)
    K = stiffK(Geo,Mat,Set);

    fix = Geo.fix;
    dof = Geo.dof;
    
    u_f = zeros(size(Geo.u));
    u = vec_nvec(Geo.u);
    
    u(dof) = K(dof,dof)\(-K(dof,fix)*u(fix));
    Result.u = ref_nvec(u, Geo.n_nodes, Geo.dim);
end