function [ukp1, sols, times] = euler_t(x, X, ts, n, x0, dof, P, mat_type, ...
                    shape_type, load_type, algo_type, n_incs)
    
    w  = [1 1];
    wx = [-1 1]/sqrt(3);
    
    K = stiffK(x,X,P,n,mat_type,shape_type);
%     K = setboundsK(K,x0);
    
    % TODO Save this as arguments...
    save = 1;
    dt   = 0.0001;
    eta  = 1;
    
    sols  = zeros(1,n_incs/save);
    times = zeros(1,n_incs/save);
    c = 0;
    t = 0;
    uk = zeros(size(x(:)));
    
    for it = 1:n_incs
        Btot = zeros(size(K));
        for e = 1:size(n,1)
            ne = n(e,:)
            for f = 1:2
                for g = 1:2
                    [dNdx, J] = getdNdx(shape_type,x,[wx(f),wx(g)]);
                    B    = getB(dNdx);
                    for a = 1:4
                        for b = 1:4
                            sl_k = (2*ne(a)-1):2*ne(a);
                            sl_l = (2*ne(b)-1):2*ne(b);
                            Btot(sl_k, sl_l) = Btot(sl_k, sl_l) + ...
                                            B(a)'*B(b)*J*w(f)*w(g);
                        end
                    end
                end
            end
        end
        Btot
        stepMatrix = Btot-(dt/eta)*K;
        stepMatrix = setboundsK(stepMatrix, x0);
        inv(Btot)
        ukp1 = Btot\(stepMatrix*uk+ts*(dt/eta));
        return
        uk = ukp1;
        
        t = t + dt;      
        
        if mod(it,save) == 0
            c = c + 1;
            sols(c) = norm(ukp1);
            times(c) = t;
        end 
    end
end
