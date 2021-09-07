function D = mneohook(x, X, z, P)
    lambda = P(1);
    mu     = P(2);
    Fd     = deformF(x,X,z);
    J = det(Fd);
    
    lambdap = lambda/J;
    mup     = (mu-lambda*log(J))/J;
    D = [lambdap + 2*mup        lambda          0
             lambda        lambdap + 2*mup      0
                0                 0            mup];
end