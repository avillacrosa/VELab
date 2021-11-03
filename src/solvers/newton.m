%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = newton(Geo, Mat, Set, Result, incr, R, F)
    uf  = vec_nvec(zeros(size(Geo.x)));
    R = R + internalF(Result.x, Geo, Mat, Set);
    if any(F)
        tol = norm(R)/norm(F);
    else
        tol = norm(R);
    end
    it = 1;
%     while(tol > Set.newton_tol || norm(uf(Geo.dof)) > Set.newton_tol)     
    while(1==1)     
        K_c = constK(Result.x, Geo, Mat, Set);        
        K_s = stressK(Result.x, Geo, Mat, Set); 

        K   = K_c + K_s;

        uf(Geo.dof) = K(Geo.dof, Geo.dof)\(-R(Geo.dof));
        Result.x   = Result.x + ref_nvec(uf, Geo.n_nodes, Geo.dim);

        T = internalF(Result.x, Geo, Mat, Set);
        R = T - F;
        if any(F)
            tol = norm(R(Geo.dof))/norm(F);
        else
            tol = norm(R(Geo.dof));
        end
        fprintf('INCR = %i, ITER = %i, tolR = %e, tolX = %e\n',...
                 incr,it,tol,norm(uf(Geo.dof)));
        it = it + 1;
    end
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end



