function K = stiffK(x, X, P, n, type)
    
    nnodes = size(x,1);
    ndim   = size(x,2);

    K = zeros(nnodes*ndim, nnodes*ndim);

    w  = [1 1];
    wx = [-1 1]/sqrt(3);
    
%     w   = [5 8 5]/9;
%     wx  = [-1 0 1]*sqrt(3/5);

    for e = 1:size(n,1)
              
        ni = n(e,:);
        xe = x(n(e,:),:);
        Xe = X(n(e,:),:);
        
        for i = 1:size(w,2)
            for j = 1:size(w,2)
                
                D  = material(type, xe, Xe, [wx(i), wx(j)], P(e,:)); 
                
                [dNdx, J] = getdNdx('square', xe, [wx(i), wx(j)]);

                B = getB(dNdx);

                for ki = 1:4
                    for li = 1:4
                        nk = ni(ki);
                        nl = ni(li);
                        sl_k = (2*nk-1):2*nk;
                        sl_l = (2*nl-1):2*nl;
                        Bk = squeeze(B(ki,:,:));
                        Bl = squeeze(B(li,:,:));
                        K(sl_k,sl_l) = K(sl_k,sl_l)+(Bk'*D*Bl)*w(i)*w(j)*J;
                    end
                end
            end
        end
    end
end