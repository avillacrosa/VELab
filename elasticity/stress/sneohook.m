function sigma = sneohook(Fd, lambda, mu)
    J      = det(Fd);
    
    b = Fd*Fd';
    sigma = mu*(b-eye(size(b)))/J+lambda*log(J)*eye(size(b))/J;
end