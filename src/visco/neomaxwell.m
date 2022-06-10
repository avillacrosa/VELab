function [sigma, q] = neomaxwell(Fd, Fd_n, q_n, Mat, Set, dim)
	tau_a = Mat.visco/Mat.E;
	xi = -Set.dt/(2*tau_a);
	J = det(Fd);
	J_n = det(Fd_n);
	b = Fd*Fd';
	b_n = Fd_n*Fd_n';
	sigma   = Mat.mu*(b-eye(size(b)))/J+Mat.lambda*log(J)*eye(size(b))/J;
	sigma_n = Mat.mu*(b_n-eye(size(b_n)))/J_n+Mat.lambda*log(J_n)*eye(size(b_n))/J_n;

% 	sigma = neohookean(Fd, Mat, dim);
% 	sigma_n = neohookean(Fd_n, Mat, dim);

	h = exp(xi)*(exp(xi)*ref_mat(q_n)-sigma_n);
	q = exp(xi)*sigma+h;

% 	sigma = neohookean(Fd, Mat, dim)+q;
% 	q = exp(2*xi)*ref_mat(q_n)+(1-exp(2*xi))/(Set.dt/tau_a)*(neohookean(Fd, Mat, dim)-neohookean(Fd_n, Mat, dim));
	sigma = q;
% 	sigma = neohookean(Fd, Mat, dim);

end