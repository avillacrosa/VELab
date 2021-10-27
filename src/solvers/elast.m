%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = elast(Geo, Mat, Set, Result)
    ndim   = Geo.dim;
    nnodes = Geo.n_nodes;
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);
        
    % As a superficial load
    df = Geo.f / Set.n_steps;
    
    u = zeros(size(vec_nvec(Geo.u)));
    
    du = Geo.u/ Set.n_steps;
    
    Result.xt = zeros(Set.n_steps, size(Geo.x,1), size(Geo.x,2));
    Result.ut = zeros(Set.n_steps, size(Geo.x,1), size(Geo.x,2));
    
    for i = 1:Set.n_steps
        F  = F + df; 
        R  = R - df;
        Geo.x = Geo.X + du;
        x_v = vec_nvec(Geo.x);
        Geo = newton(Geo, Mat, Set, i, R, F, x_v, u);
        Result.xt(i,:,:) = Geo.x;
        Result.ut(i,:,:) = Geo.x - Geo.X;
    end
    Result.u = Geo.x - Geo.X;
    Result.Ff = ref_nvec(F, Geo.n_nodes, Geo.dim);
    Result.Fb = zeros(size(Result.Ff));
    Rv = ref_nvec(R, Geo.n_nodes, Geo.dim);
    Result.Fb(Geo.dof) = Rv(Geo.dof);
end



