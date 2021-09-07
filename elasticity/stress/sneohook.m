function sigma = sneohook(Fd, P)
    lambda = P(1);
    mu     = P(2);
    J      = det(Fd);
    
    b = Fd*Fd';
    sigma = mu*(b-eye(size(b)))/J+lambda*log(J)*eye(size(b))/J;
end