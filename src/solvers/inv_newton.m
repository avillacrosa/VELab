%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Geo = inv_newton(Geo, Mat, Set, incr, R, F, x_v, u)
    it = 1;
    T = internalF(Geo.x, Geo, Mat, Set);
    R = T;
    tol = norm(R);
    while(tol > Set.newton_tol || norm(u(Geo.dof)) > Set.newton_tol)
        K_c = stiffK(Geo, Mat, Set);
        K_s = initStressK(Geo, Mat, Set); 
        
        K = K_c + K_s;

        u(Geo.dof) = K(Geo.dof, Geo.dof)\(-R(Geo.dof));

        x_v = x_v + u;
        Geo.x   = ref_nvec(x_v, Geo.n_nodes, Geo.dim);

        T = internalF(Geo.x, Geo, Mat, Set);
        R = T;
        tol = norm(R(Geo.dof));
        fprintf('INCR=%i ITER = %i tolR = %e tolX = %e\n',...
                 incr,it,tol,norm(u(Geo.dof)));
        it = it + 1;
    end
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end



