% function x = newton(t, x, n, x0, dx0, P, n_inc, mat_type)
function x = newton(x, X, t, n, x0, dof, P, mat_type, ...
                    shape_type, load_type, max_tol, n_ints)

    ndim   = size(x,2);
    nnodes = size(x,1);
    
    F = zeros(ndim*nnodes,1); 
    R = zeros(ndim*nnodes,1);

    % As a superficial load
    dp = t / n_ints;
    for i = 1:n_ints
        DF = integrateF(x, dp, n, shape_type);
        F  = F + DF; 
        R  = R - DF;
        it = 1;
        tol = norm(R)/norm(F);
        while(tol > max_tol)
            K_c = stiffK(x, X, P, n, mat_type, shape_type);
            K_s = initStressK(x, X, P, n, mat_type, shape_type);
            
            K = K_c + K_s;
            K = setboundsK(K, x0);
            
            RBc = zeros(size(R));
            RBc(dof) = R(dof);
            u = K\(-RBc);
            
            u = reshape(u,[ndim,nnodes])';
            
            x = x + u;
            
            T = internalF(x, X, P, n, mat_type, shape_type);
            
            R = T-F;
            tol = norm(R(dof))/norm(F);
            fprintf('INCR=%i ITER = %i tolR = %e tolX=%e\n', i,it,tol,norm(u))
            it = it + 1;
        end
    end
end



