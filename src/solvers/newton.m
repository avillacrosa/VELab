%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = newton(Geo, Mat, Set, Result, incr, R, F)
    uf  = vec_nvec(zeros(size(Geo.X)));
    tol = norm(R(Geo.dof))/Geo.x_units; 
    it = 1;
    while(tol > Set.newton_tol)
        if strcmpi(Mat.type, 'hookean'), x = Geo.X; else, x = Result.x; end
        K_c                  = constK(x, Geo, Mat, Set);        
        [K_s, Result.sigmas] = stressK(x, Geo, Mat, Set); 

        K   = K_c + K_s;

        uf(Geo.dof) = K(Geo.dof, Geo.dof)\(-R(Geo.dof));
        Result.x   = Result.x + ref_nvec(uf, Geo.n_nodes, Geo.dim);

        T = internalF(Result.x, Geo, Mat, Set);
        R = T - F;
        tol = norm(R(Geo.dof))/Geo.x_units;
        fprintf('INCR = %i, ITER = %i, tolR = %e, tolX = %e\n',...
                 incr,it,tol,norm(uf(Geo.dof)));
        it = it + 1;
    end
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end



