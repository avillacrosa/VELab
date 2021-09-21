function D = mneohook(x, X, z, lambda, mu)
    Fd     = deformF(x,X,z, 'square');
    dim = size(x,2);
    J = det(Fd);
    
    lambdap = lambda/J;
    mup     = (mu-lambda*log(J))/J;
    if dim == 2
        D = [lambdap + 2*mup        lambdap          0
                 lambdap        lambdap + 2*mup      0
                    0                 0            mup];
    elseif dim == 3
        D = [lambdap + 2*mup        lambdap          lambdap       0  0  0 
                 lambdap        lambdap + 2*mup      lambdap       0  0  0
                 lambdap            lambdap      lambdap + 2*mup   0  0  0
                    0                 0                 0         mup 0  0
                    0                 0                 0          0 mup 0
                    0                 0                 0          0  0 mup
                    ];
    end
end