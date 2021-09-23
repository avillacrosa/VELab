function [sigma, c] = hookean(Fd, lambda, mu, dim)
    lin_str = (Fd'+Fd)/2-eye(size(Fd));
    c = zeros(dim, dim, dim, dim);

    if Fd == eye(size(Fd)) % Plain stress case, correct lambda
        lambda = lambda*(1-lambda/(lambda+2*mu));
    end
    
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    c(i,j,k,l) = lambda*kron(i,j)*kron(k,l) ...
                                    + 2*mu*kron(i,k)*kron(j,l);
                end
            end
        end
    end

    sigma = zeros(size(Fd));
    for k = 1:dim
        for l = 1:dim
            sigma = sigma + c(:,:,k,l)*lin_str(k,l);
        end
    end
    
    
end