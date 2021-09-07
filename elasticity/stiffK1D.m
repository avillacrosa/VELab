function K = stiffK(x, X, P, n, type)
    
    nnodes = size(x,1);
    ndim   = size(x,2);

    K = zeros(nnodes*ndim, nnodes*ndim);
    % 2-point 2D Gaussian quadrature
    w  = [1 1];
    wx = [-1 1]/sqrt(3);
    
%     w   = [5 8 5]/9;
%     wx  = [-1 0 1]*sqrt(3/5);

    for e = 1:size(n,1)
              
        ni = n(e,:);
        xe = x(n(e,:),:);
%         Xe = X(n(e,:),:);
        
        for i = 1:size(w,2)
            for j = 1:size(w,2)
                E  = P(e,1);
                nu = P(e,2);
                D  = E/(1-nu)^2;
                
                dNdz = [-1; 1]/2;
                dxdz = xe'*dNdz;
                dNdx = (dxdz\dNdz')';
                J    = det(dxdz);
                
                B1 = [dNdx(1)
                            dNdx(1)];
                B2 = [dNdx(2)
                            dNdx(2)];
                B = [B1, B2];
                for ki = 1:2
                    for li = 1:2
                        nk = ni(ki);
                        nl = ni(li);
                        Bk = B(ki);
                        Bl = B(li);
                        K(nk,nl) = K(nk,nl)+(Bk'*D*Bl)*w(i)*w(j)*J;
                    end
                end
            end
        end
    end
end