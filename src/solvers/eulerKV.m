%--------------------------------------------------------------------------
% Solve a kelvin-voigt linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_t, T_t]  = eulerKV(u_t, dof, fix, dt, k, F_t, T_t, K, BB, Mat, Set)
    edt = Mat.visco/dt;
	if strcmpi(Set.euler, 'forward')
		u_t(dof,k+1) = B(dof,dof)\...
						(F_t(dof,k)/edt...
			 			-K(dof,dof)*u_t(dof,k)/edt...
			 			-K(dof,fix)*u_t(fix,k)/edt...
			 			-BB(dof,fix)*(u_t(fix,k+1)-u_t(fix,k))...
			 			-BB(dof,dof)*u_t(dof,k));
		T_t(fix,k) = -K(fix,fix)*u_t(fix,k)/edt...
					 -K(fix,dof)*u_t(dof,k)/edt...
					 -BB(fix,fix)*(u_t(fix,k+1)-u_t(fix,k))...
					 -BB(fix,dof)*(u_t(dof,k+1)-u_t(dof,k));
	elseif strcmpi(Set.euler, 'backward')
		u_t(dof,k+1) = (K(dof,dof)+B(dof,dof))\...
						(F_t(dof,k+1)...
 						-K(dof,fix)*u_t(fix,k+1)...
 						-BB(dof,dof)*u_t(dof,k)...
 						-BB(dof,fix)*u_t(fix,k+1)...
 						-BB(dof,fix)*u_t(fix,k));
		T_t(fix,k+1) = -K(fix,fix)*u(fix,k+1)...
					   -K(fix,dof)*u(dof,k+1)...
					   -BB(fix,fix)*(u_t(fix,k+1)-u_t(fix,k))*edt...
					   -BB(fix,dof)*(u_t(dof,k+1)-u_t(dof,k))*edt;
	end
end
