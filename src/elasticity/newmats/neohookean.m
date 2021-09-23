function [sigma, c] = neohookean(Fd, lambda, mu, dim)
    J = det(Fd);
    b = Fd*Fd';
    
    lp = lambda/J;
    mp = (mu-lambda*log(J))/J;
    
    c = zeros(dim, dim, dim, dim);
    
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    c(i,j,k,l) = lp*kron(i,j)*kron(k,l) ...
                        + 2*mp*kron(i,k)*kron(j,l);
                end
            end
        end
    end
    sigma = mu*(b-eye(size(b)))/J+lambda*log(J)*eye(size(b))/J;
end