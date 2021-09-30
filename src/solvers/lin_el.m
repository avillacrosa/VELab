%--------------------------------------------------------------------------
% Direct linear (hookean) elasticity solver
%--------------------------------------------------------------------------
function Result = lin_el(Geo, Mat, Set, Result)
    u = Geo.u';
    u = u(:);
    K     = stiffK(Geo, Mat, Set);
    corrR = K(Geo.dof, Geo.fix)*u(Geo.fix);
    u(Geo.dof)  = K(Geo.dof, Geo.dof)\(Geo.f(Geo.dof)-corrR);
    u = reshape(u, [Geo.dim, Geo.n_nodes])';
    x = Geo.x + u;
    Result.u = u;
    Result.x = x;
    Result.K = K;
end