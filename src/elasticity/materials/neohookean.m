function sigma = neohookean(Fd, Mat, dim)
    J = det(Fd);
    b = bStrain(Fd);
    sigma = Mat.mu*(b-eye(size(b)))/J+Mat.lambda*log(J)*eye(size(b))/J;
end