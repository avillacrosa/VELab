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
        for j = 1:size(w,2)
            for k = 1:size(w,2)
                Fd = deformF(xe,Xe,[wx(j),wx(k)]);
                sigma = stress(mat_type, Fd, P(e,:));
                [dNdx, J] = getdNdx(sh_type, xe, [wx(j), wx(k)]); 
                % FIXIT HARDCODE
                for m = 1:4 
                    for ll = 1:ndim
                        for l = 1:ndim 
                            idx = 2*(n(e,m)-1)+ll;
                            T(idx) = T(idx) + sigma(ll,l)'*dNdx(m,l)*J*w(j)*w(k);
                        end
                    end
                end
            end
        end
    end
end