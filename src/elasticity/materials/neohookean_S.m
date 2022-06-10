function S = neohookean_S(Fd, Mat, dim)
    J = det(Fd);
    b = bStrain(Fd);
	C = Fd'*Fd;
%     sigma = Mat.mu*(b-eye(size(b)))/J+Mat.lambda*log(J)*eye(size(b))/J;
	S = Mat.mu*(eye(size(C))-inv(C))+Mat.lambda*log(J)*inv(C);
end