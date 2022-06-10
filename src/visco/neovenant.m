function [sigma, q] = neovenant(Fd, Fd_n, q_n, Mat, Set, dim)
	tau_a = Mat.visco/Mat.E;
	xi = -Set.dt/(2*tau_a);
    J    = det(Fd);
    E    = EStrain(Fd); % OK
	E_n  = EStrain(Fd_n); % OK
    
    S    = Mat.lambda*trace(E)*eye(size(E)) + 2*Mat.mu*E;
	S_n  = Mat.lambda*trace(E_n)*eye(size(E_n)) + 2*Mat.mu*E_n;

	h = exp(xi)*(exp(xi)*ref_mat(q_n)-S_n);
	q = exp(xi)*S+h;
	
% 	sigma = neohookean(Fd, Mat, dim)+q;
% 	q = exp(2*xi)*ref_mat(q_n)+(1-exp(2*xi))/(Set.dt/tau_a)*(neohookean(Fd, Mat, dim)-neohookean(Fd_n, Mat, dim));
	S_tot = q;
	sigma = Fd*S_tot*Fd'/J;

% 	sigma = neohookean(Fd, Mat, dim);

end