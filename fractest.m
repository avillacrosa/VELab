ca = 594710.82;
cb = 38338.84;
a = 0.33;
b = 0.03;
dt = 1e-10;
niter = 50;
sigma = zeros(niter,1);
sigma(1) = 1;
eps0 = 0.01;
for k = 1:(niter-1)
    lambda = 1;
    frac_term = 0;
    for j = 2:k
        frac_term = lambda*sigma(k-j+1);
        lambda = lambda*(j-1-(a-b))/j;
    end
%     sigma(k+1) = dt^(a-b)*eps0*cb-dt^(a-b)*sigma(k)*cb/ca-frac_term;
    sigma(k+1) = -dt^(a-b)*sigma(k)*cb/ca+frac_term;

end
plot((1:niter)*dt, sigma , 'o') 