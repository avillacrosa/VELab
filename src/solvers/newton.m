%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function Result = newton(Geo, Mat, Set, Result)

    ndim   = Geo.dim;
    nnodes = Geo.n_nodes;
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);
        
    % As a superficial load
    Geo.f = Geo.f / Set.newton_its;
    u = zeros(size(Geo.x));
    for i = 1:Set.newton_its
        % TODO this should be included if we want real superficial tensions
%         DF = integrateF(Geom, Set);
        DF = Geo.f;
        F  = F + DF; 
        R  = R - DF;
        it = 1;
        tol = norm(R)/norm(F);
        while(tol > Set.newton_tol || norm(u) > Set.newton_tol)
            K_c = stiffK(Geo, Mat, Set); 
            K_s = initStressK(Geo, Mat, Set); 
            K = K_c + K_s;
            
            K = setboundsK(K, Geo);
            RBc = zeros(size(R));
            RBc(Geo.dof) = R(Geo.dof);
            u = K\(-RBc);
            u = reshape(u,[ndim,nnodes])';
            Geo.x = Geo.x + u;
            T = internalF(Geo, Mat, Set);
            R = T-F;
            tol = norm(R(Geo.dof))/norm(F);
            fprintf('INCR=%i ITER = %i tolR = %e tolX = %e\n', i,it,tol,norm(u));
            it = it + 1;
        end
        fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", i, it);
    end
    Result.x = Geo.x;
    Result.u = Geo.x - Geo.X;
end



