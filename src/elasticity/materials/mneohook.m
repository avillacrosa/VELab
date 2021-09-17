function D = mneohook(x, X, z, lambda, mu)
    Fd     = deformF(x,X,z, 'square');
    J = det(Fd);
    
    lambdap = lambda/J;
    mup     = (mu-lambda*log(J))/J;
    D = [lambdap + 2*mup        lambdap          0
             lambdap        lambdap + 2*mup      0
                0                 0            mup];
end