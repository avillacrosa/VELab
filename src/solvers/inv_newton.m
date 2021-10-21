%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Geo = inv_newton(Geo, Mat, Set, incr, R, x_v)
    
    it = 1;
    dR = zeros(size(R));
    R = zeros(size(dR));
    
    tol = 1000000;
    dof = Geo.dof;
    u = vec_nvec(Geo.u);
    u = zeros(size(u));
        
    T = internalF(Geo, Mat, Set);
    F = T - R;
    
%     while(tol > Set.newton_tol)
    while(1)
        K_c = stiffK(Geo, Mat, Set);
        K_s = initStressK(Geo, Mat, Set); 
        K = K_c + K_s;
        
        dR(Geo.dof) = -K(Geo.dof, Geo.dof)*u(Geo.dof);
        R(dof) = R(dof) + dR(dof);
        
        u(Geo.dof) = K(Geo.dof, Geo.dof)\(-R(Geo.dof));
        
        x_v = x_v + u;
        Geo.x   = ref_nvec(x_v, Geo.n_nodes, Geo.dim);
        it = it + 1;
    end
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end



