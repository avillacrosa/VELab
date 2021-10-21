%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = inv_elast(Geo, Mat, Set, Result)
    ndim   = Geo.dim;
    nnodes = Geo.n_nodes;
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);

    x_v = vec_nvec(Geo.x);
    
    du = Geo.u/ Set.n_steps;
    
    Result.xt = zeros(Set.n_steps, size(Geo.x,1), size(Geo.x,2));
    Result.ut = zeros(Set.n_steps, size(Geo.x,1), size(Geo.x,2));
    
    for i = 1:Set.n_steps
        Geo.x = Geo.X + du;
        f = inv_newton(Geo, Mat, Set, i, F, vec_nvec(Geo.x));
        
    end
end



