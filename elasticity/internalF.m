function T = internalF(x,X,P)
    ndim   = size(x,2);
    nnodes = size(x,1);
    
    wx = [-1 1]/sqrt(3);
    w  = [1 1];
    
    c = material(type, P);
          
    T = zeros(nnodes, ndim);
    % Integration of T is scuffed 
    for j = 1:2
        for k = 1:2
            Fd = deformF(x,X,[wx(j),wx(k)]);

            strain   =  (Fd'+Fd)/2-eye(size(Fd));
            
            sigma = stress(type, c, strain);

            [dNdx, J] = getdNdx(type, x, [wx(j), wx(k)]); 

            for m = 1:nnodes % Nodes
                for l = 1:ndim % Dims
                    T(m,:) = T(m,:) + sigma(:,l)'*dNdx(m,l)*J*w(j)*w(k); 
                end
            end
        end
    end
    T = T';
    T = T(:);
end