function K = initStressK(x, X, P, n, mat_type, shape_type)
    
    nnodes = size(x,1);
    ndim   = size(x,2);

    K = zeros(nnodes*ndim, nnodes*ndim);
    w  = [1 1];
    wx = [-1 1]/sqrt(3);
    
    for e = 1:size(n,1)
              
        ni = n(e,:);
        xe = x(n(e,:),:);
        Xe = X(n(e,:),:);
        for int_i = 1:size(w,2)
            for int_j = 1:size(w,2)

                Fd = deformF(xe,Xe,[wx(int_i),wx(int_j)], shape_type);
                sigma = stress(mat_type, Fd, P(e,:));
                [dNdx, J] = getdNdx(shape_type, xe, [wx(int_i), wx(int_j)]);

                for ki = 1:4
                    for li = 1:4
                        nk = ni(ki);
                        nl = ni(li);
                        sl_k = (2*nk-1):2*nk;
                        sl_l = (2*nl-1):2*nl;
                        K(sl_k,sl_l) = K(sl_k,sl_l)+...
                                       dNdx(ki,:)*sigma*dNdx(li,:)'*eye(ndim);

                    end
                end
            end
        end
    end    
end