function x = newton(t, x, n, x0, dx0, P, n_inc)
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
        DF = load_sum(p);
        DF = dp
        % At some point I should decide on the notation...
        DF = DF';
        DF = DF(:);
        F  = F + DF; %LOAD! not deformation
        R  = R - DF;
        
        it = 0;
        while(norm(R)/norm(F) > 0.001)
            K = zeros(nnodes*ndim, nnodes*ndim);    
            K = buildK(K, x, P, n);
            K = setbounds(K, R, x0, dx0, n);
            u = K\(-R);
            u = reshape(u,[2,4])';
            x = x + u;
            % 2 point 2-D gaussian quadrature
            T = intT(x,X,P);
            R = T-F;
            R(1) = 0;
            R(7) = 0;
            it = it + 1;
        end
    end
end



