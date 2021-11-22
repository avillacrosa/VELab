function c = hookean_c(Fd, Mat, dim)
    c = zeros(dim, dim, dim, dim);

    % TODO incorporate plane strain or general behavior
    % Plane stress correction
    lambda_c = Mat.lambda*(1-Mat.lambda/(Mat.lambda+2*Mat.mu)); 
    for i = 1:dim
        for j = 1:dim
            for k = 1:dim
                for l = 1:dim
                    c(i,j,k,l) = lambda_c*kronD(i,j)*kronD(k,l) ...
                                    + 2*Mat.mu*kronD(i,k)*kronD(j,l);
                end
            end
        end
    end
end