function [sigma, q] = neomaxwell_S(Fd, Fd_n, q_n, Mat, Set, dim)
	tau_a = Mat.visco/Mat.E;
	xi = -Set.dt/(2*tau_a);
	J = det(Fd);
	J_n = det(Fd_n);
	C = Fd'*Fd; invC = inv(C);
	C_n = Fd_n'*Fd_n; invC_n = inv(C_n);
	S   = Mat.mu*(eye(size(C))-invC)+Mat.lambda*log(J)*invC;
	S_n = Mat.mu*(eye(size(C_n))-invC_n)+Mat.lambda*log(J_n)*invC_n;

	h = exp(xi)*(exp(xi)*ref_mat(q_n)-S_n);
	Q = exp(xi)*S+h;
% 	S = S+q;
	S = Q;
	sigma = Fd*S*Fd'/J;

	q = Q;
% 	q = exp(2*xi)*ref_mat(q_n)+(1-exp(2*xi))/(Set.dt/tau_a)*(neohookean(Fd, Mat, dim)-neohookean(Fd_n, Mat, dim));
% 	sigma = q;
% 	sigma = neohookean(Fd, Mat, dim);

end