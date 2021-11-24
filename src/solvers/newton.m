%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = newton(Geo, Mat, Set, Result, incr, R, F)
    uf  = vec_nvec(zeros(size(Geo.X)));
    tol = norm(R);
    it = 1;
%     while(tol > Set.newton_tol || norm(uf(Geo.dof)) > Set.newton_tol)
    while(it < 3)

        if strcmpi(Mat.type, 'hookean')
            K_c = constK(Geo.X, Geo, Mat, Set);        
            K_s = stressK(Geo.X, Geo, Mat, Set); 
        else
            K_c = constK(Result.x, Geo, Mat, Set);        
            K_s = stressK(Result.x, Geo, Mat, Set); 
        end

        K   = K_c + K_s;

        uf(Geo.dof) = K(Geo.dof, Geo.dof)\(-R(Geo.dof));
        Result.x   = Result.x + ref_nvec(uf, Geo.n_nodes, Geo.dim);

        T = internalF(Result.x, Geo, Mat, Set);
        R = T - F;
        tol = norm(R(Geo.dof));
        fprintf('INCR = %i, ITER = %i, tolR = %e, tolX = %e\n',...
                 incr,it,tol,norm(uf(Geo.dof)));
        it = it + 1;
    end
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end



