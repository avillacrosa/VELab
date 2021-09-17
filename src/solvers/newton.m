function Result = newton(Geom, Mat, Set, Result)

    ndim   = Geom.dim;
    nnodes = Geom.n_nodes;
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);
        
    % As a superficial load
    Set.newton_its
    Geom.f = Geom.f / Set.newton_its;
    u = zeros(size(Geom.x));
    for i = 1:Set.newton_its
        DF = integrateF(Geom, Set);
        F  = F + DF; 
        R  = R - DF;
        it = 1;
        tol = norm(R)/norm(F);
        while(tol > Set.newton_tol || norm(u) > Set.newton_tol )
            K_c = stiffK(Geom, Mat, Set); 
            K_s = initStressK(Geom, Mat, Set); 
            K = K_c + K_s;
            
            K = setboundsK(K, Geom.x0);
            
            RBc = zeros(size(R));
            RBc(Geom.dof) = R(Geom.dof);
            u = K\(-RBc);
            u = reshape(u,[ndim,nnodes])';
            Geom.x = Geom.x + u;
            T = internalF(Geom, Mat, Set);
            R = T-F;
            tol = norm(R(Geom.dof))/norm(F);
            fprintf('INCR=%i ITER = %i tolR = %e tolX=%e\n', i,it,tol,norm(u));
            it = it + 1;
        end
    end
    Result.x = Geom.x;
    Result.u = Geom.x - Geom.X;
end



