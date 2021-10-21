function [sigma, c] = hookean(Fd, lambda, mu, dim)
    lin_str = (Fd'+Fd)/2-eye(size(Fd));
    c = zeros(dim, dim, dim, dim);

    % TODO incorporate plane strain or general behavior
    lambda_c = lambda*(1-lambda/(lambda+2*mu)); % Plane stress correction
    
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    c(i,j,k,l) = lambda_c*kronD(i,j)*kronD(k,l) ...
                                    + 2*mu*kronD(i,k)*kronD(j,l);
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