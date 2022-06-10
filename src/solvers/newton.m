%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function [u, stress] = newton(u, dof, fix, incr, R, F, Geo, Mat, Set)
    tol = norm(R(Geo.dof))/Geo.x_units; 
    it  = 1;
    X = vec_nvec(Geo.X);
    while(tol > Set.newton_tol)
        if strcmpi(Mat.type, 'hookean'), x = X; else, x = X + u; end
        K_c           = constK(x, Geo, Mat, Set);        
        [K_s, stress] = stressK(x, Geo, Mat, Set); 

        K   = K_c + K_s;
        du = K(dof, dof)\(-R(dof));
        u(dof) = u(dof) + du;
        x = X + u;
        T = internalF(x, Geo, Mat, Set);
        R = T - F;
        tol = norm(R(dof))/Geo.x_units;
        fprintf('INCR = %i, ITER = %i, tolR = %e, tolX = %e\n',...
                 incr,it,tol,norm(du));
        it = it + 1;
    end
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end
