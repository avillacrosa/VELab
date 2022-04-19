function E = mlf(alpha, beta, N, z)
    E = zeros(size(z));
    for k = 0:N
        dE = z.^k./gamma(alpha*k+beta);
        E = E+dE;
    end
end