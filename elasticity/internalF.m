function T = internalF(x, X, P, n, mat_type, sh_type)

    ndim   = size(x,2);
    nnodes = size(x,1);
    
    wx = [-1 1]/sqrt(3);
    w  = [1 1];
    
%     w   = [5 8 5]/9;
%     wx  = [-1 0 1]*sqrt(3/5);
    
          
    T = zeros(nnodes*ndim, 1);
    for e = 1:size(n,1)
        xe = x(n(e,:),:);
        Xe = X(n(e,:),:);
        for m = 1:size(xe,1) 
            for j = 1:size(w,2)
                for k = 1:size(w,2)
                    Fd = deformF(xe,Xe,[wx(j),wx(k)], sh_type);
                    sigma = stress(mat_type, Fd, P(e,:));
                    [dNdx, J] = getdNdx(sh_type, xe, [wx(j), wx(k)]); 
                    int = sigma*dNdx(m,:)'*J*w(j)*w(k);
                    for ll = 1:ndim
                        idx = 2*(n(e,m)-1)+ll;
                        T(idx) = T(idx) + int(ll);
                    end
                end
            end
        end
    end
end