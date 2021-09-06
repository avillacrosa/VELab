function x = newton(t, x, n, x0, dx0, P, n_inc, mat_type)
    nelem  = size(n,1);
    ndim   = size(x,2);
    nnodes = size(x,1);
    X = x;
    
    F = zeros(ndim*nnodes,1); %LOAD! not deformation
    R = zeros(ndim*nnodes,1);
    p = zeros(nnodes, ndim);

    dp = t / n_inc;
%     K  = zeros(nnodes*ndim, nnodes*ndim);    
    
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
%         while(tol > 0.00001)
        while(it < 1)
            K = stiffK(x, P, n, mat_type);
            K = setboundsK(K, x0, n);
            u = K\(-R);
            u = reshape(u,[ndim,nnodes])';
            x = x + u;
            T = internalF(x, X, P, n, mat_type, 'square');
            T
            R = T-F;
            norm(R), norm(T)
            
            tol = convergence(R, F, x0);
            disp(["Current tolerance", tol, "It", it])
            
            it = it + 1;
%             break
        end
        break
    end
end



