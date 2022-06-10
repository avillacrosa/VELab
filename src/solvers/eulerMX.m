%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_t, T_t] = eulerMX(u_t, dof, fix, dt, k, F_t, T_t, K, BB, Mat, Set)
	edt = Mat.visco/dt;
	if strcmpi(Set.euler, 'forward')
		BK = BB*K;
		u_t(dof,k+1) = B(dof,dof)\...
						(F(dof,k)/edt...
						+BK(dof,dof)*(F(dof,k+1)-F(dof,k))...
						-BK(dof,fix)*(T(fix,k+1)-T(fix,k))...
						-BB(dof,dof)*u_t(dof,k)...
						-BB(dof,fix)*(u_t(fix,k+1)-u_t(fix,k)));
		T_t(fix,k+1) = BB(fix,fix)\...
					    -T(fix,k)/edt...
						-BB(fix,fix)*(u(fix,k+1)-u(fix,k))...
						-BB(fix,dof)*(u(dof,k+1)-u(dof,k))...
						-BK(fix,fix)*T_t(fix,k)...
						-BK(fix,dof)*(F_t(dof,k+1)-F_t(dof,k));
	elseif strcmpi(Set.euler, 'backward')
		BK = BB*K;
		u_t(dof,k+1) = B(dof,dof)\...
						(F(dof,k+1)/edt...
			          	+BK(dof,dof)*(F(dof,k+1)-F(dof,k))...
			          	-BK(dof,fix)*(T_t(fix,k+1)-T_t(fix,k))...
			          	-BB(dof,dof)*u_t(dof,k)...
			          	-B(dof,fix)*(u_t(fix,k+1)-u_t(fix,k)));
		T_t(fix,k+1) = (eye(BK)/edt+BK(fix,fix))\...
						(-T_t(fix,k)/edt...
						 -BB(fix,fix)*(u_t(fix,k+1)-u_t(fix,k))...
						 -BB(fix,dof)*(u_t(dof,k+1)-u_t(dof,k))...
						 -BK(fix,fix)*T_t(fix,k)...
						 -BK(fix,dof)*(F(fix,k+1)-F(fix,k)));...
	end
end   
