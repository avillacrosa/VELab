function [sigma, c] = venant(Fd, lambda, mu, dim)
    J    = det(Fd);
    E    = 0.5*(Fd'*Fd-eye(size(Fd)));
    
    C    = zeros(dim, dim, dim, dim);
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    C(i,j,k,l) = lambda*kron(i,j)*kron(k,l) ...
                                 +2*mu*kron(i,k)*kron(j,l);
                end
            end
        end
    end
    
    c = eulerTensor(C, Fd, dim);
    
    S    = lambda*trace(E)*eye(size(E)) + 2*mu*E;
    sigma = Fd*S*Fd'/J;
end