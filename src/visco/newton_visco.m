%--------------------------------------------------------------------------
% Newton-Raphson solver for nonlinear elasticity
%--------------------------------------------------------------------------
function [u, stress, q_t] = newton_visco(k, u, q_t, dof, fix, incr, R, F, Geo, Mat, Set)
    tol = norm(R(Geo.dof))/Geo.x_units; 
    it  = 1;
    X = vec_nvec(Geo.X);
	while(tol > Set.newton_tol)
		if strcmpi(Mat.type, 'hookean'), x = X; else, x = X + u; end
		K_c              = constK_v(k, x, q_t, Geo, Mat, Set);        
		[K_s, stress, q_t(:,:,:,k+1)] = stressK_v(k, x, q_t, Geo, Mat, Set); 
		
		K   = K_c + K_s;
		du = K(dof, dof)\(-R(dof));
		u(dof,k+1) = u(dof,k+1) + du;
		x = X + u;
		T = internalF_v(k, x, q_t, Geo, Mat, Set);
		R = T - F;
		tol = norm(R(dof))/Geo.x_units;
		fprintf('INCR = %i, ITER = %i, tolR = %e, tolX = %e\n',...
         		incr,it,tol,norm(du));
		it = it + 1;
	end
%     [~, ~, q_t(:,:,:,k+1)] = stressK_v(k, x, q_t, Geo, Mat, Set); 
    fprintf("> INCR %i CONVERGED IN %i ITERATIONS \n", incr, it-1);
end
