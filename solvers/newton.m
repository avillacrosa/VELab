function Result = newton(Topo, Material, Numerical, Result)

    ndim   = Topo.dim;
    nnodes = Topo.totn;
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);
        
    % As a superficial load
    Topo.f = Topo.f / Numerical.n_iter;
    u = zeros(size(Topo.x));
    for i = 1:Numerical.n_iter
        DF = integrateF(Topo);
        F  = F + DF; 
        R  = R - DF;
        it = 1;
        tol = norm(R)/norm(F);
        while(tol > Numerical.min_tol || norm(u) > Numerical.min_tol )
            K_c = stiffK(Topo, Material); 
            K_s = initStressK(Topo, Material); 
            K = K_c + K_s;
            
            K = setboundsK(K, Topo.x0);
            
            RBc = zeros(size(R));
            RBc(Topo.dof) = R(Topo.dof);
            u = K\(-RBc);
            u = reshape(u,[ndim,nnodes])';
            Topo.x = Topo.x + u;
            T = internalF(Topo, Material);
            R = T-F;
            tol = norm(R(Topo.dof))/norm(F);
            fprintf('INCR=%i ITER = %i tolR = %e tolX=%e\n', i,it,tol,norm(u));
            it = it + 1;
        end
    end
    Result.x = Topo.x;
    Result.u = Topo.x - Topo.X;
end



