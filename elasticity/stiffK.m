function K = stiffK(x, P, n, type)
    
    nnodes = size(x,1);
    ndim   = size(x,2);

    K = zeros(nnodes*ndim, nnodes*ndim);
    % 2-point 2D Gaussian quadrature
    w  = [1 1];
    wx = [-1 1]/sqrt(3);
        
    for e = 1:size(n,1)
        D  = material(type, P(e,:));   
              
        ni = n(e,:);
        xe = x(n(e,:),:);
        
        for i = 1:2
            for j = 1:2
                
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