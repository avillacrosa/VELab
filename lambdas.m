

las = [0, 0.2, 0.4, 0.6, 0.8, 1.0];
for l = 1:length(las)
    ll = las(l)
    k = 100;
    plot(1:k,lambdasc(ll,k))
    hold on
end

function lambdastore = lambdasc(rho,k)
    lambdastore = zeros(size(k));
    lambda = 1;
    for j = 1:k 
        lambdastore(j)=lambda;
        lambda = lambda*(j-1-rho)/j;
    end
end