function gl = glderiv(f, k, dt, rho, j0, cutoff)
    gl = zeros(size(f,1), 1);
    lambda = 1;
%     lambdas = zeros(k+1,1);
    for j = 1:(k+1) 
        if j >= j0
            gl = gl + lambda*f(:,k-j+2);
        end
        lambda = lambda*(j-1-rho)/j;
        if j > cutoff
            break
        end
%         lambdas(j)=lambda;
    end
    gl = gl*dt^(-rho);
end