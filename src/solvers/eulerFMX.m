%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_kp1, stress_kp1, F_k] = eulerFMX(u, k, F_k, K, BB, Geo, Set, Mat)

    gl_eps = glderiv(u,k,Set.dt,Mat.alpha,2,1e6);
    gl_eps = gl_eps*Set.dt^(Mat.alpha);

	% TODO FIXME, this is not ukp1 but uk
	u_kp1 = u(:,k);

    dof = Geo.dof; fix = Geo.fix;

    u_kp1(dof) = BB(dof,dof)\(F_k(dof)*Set.dt^(Mat.alpha)/Mat.c_alpha)-gl_eps(dof);
    
%     F_k(fix)   = (BB(fix,fix)*(u_kp1(fix)-u_k(fix)) + ...
%                   BB(fix,dof)*(u_kp1(dof)-u_k(dof)))*eta/dt;

%     stress_kp1 = (eye(size(D)) - dt*D/eta)*stress_k+ D*Bvec*(u_kp1-u_k);
    % TODO TODO FIXIT BROKEN
%     stress_kp1 = stress_k;
end   
