function x = newton(t, x, n, x0, dx0, P, n_inc, mat_type)
    nelem  = size(n,1);
    ndim   = size(x,2);
    nnodes = size(x,1);
    X = x;
    nvec = n(:);
    F = zeros(ndim*nnodes,1); %LOAD! not deformation
    R = zeros(ndim*nnodes,1);
    p = zeros(nnodes, ndim);

    dp = t / n_inc;  
    
    for i = 1:n_inc
        % FIXME Placeholder (wrong)
        p = p + dp;
%         p = t;
        p(3,1) = 0;
        %REDO THIS...
        DF = externalF('square', p);
        DF = dp;
        % At some point I should decide on the notation...
        DF = DF';
        DF = DF(:);
        F  = F + DF; %LOAD! not deformation
        R  = R - DF;
        it = 0;
        tol = norm(R)/norm(F);
        while(tol > 0.001)
            K = stiffK(x, X, P, n, mat_type);
            K = setboundsK(K, x0, n);
            u = K\(-R);
            u = reshape(u,[ndim,nnodes])';
            x = x + u;
            
            T = internalF(x, X, P, n, mat_type, 'square');
            R = T-F;
            
            it = it + 1;
            tol = convergence(R, F, x0);
            disp(["Newton-Raphson tolerance", tol, "It", it])
        end
    end
end



