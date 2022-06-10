%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_t, T_t] = eulerFMX(u_t, dof, fix, dt, k, F, T_t, K, BB, Mat)
	gl_u  = glderiv(u_t,k,dt,Mat.alpha,2,1e6);
	gl_u2 = glderiv(u_t,k-1,dt,Mat.alpha,2,1e6);

	gl_F  = glderiv(F_t,k,dt,Mat.alpha-Mat.beta,2,1e6);

	gl_T  = glderiv(T_t,k,dt,Mat.alpha-Mat.beta,2,1e6);
	gl_T2 = glderiv(F_t,k-1,dt,Mat.alpha-Mat.beta,2,1e6);

	Ka = 1;
	Kb = 1;
	KaKb = Ka*Kb;

	u_t(dof,k) = Ka(dof,dof)\...
				 (F(dof,k)...
				 -K(dof,fix)*u_t(fix,k)...
				 +gl_u2(dof)...
				 +KaKb(dof,dof)*gl_F(dof)...
				 -KaKb(dof,fix)*gl_T(dof));

	T_t(dof,k) = (eye(KaKb)+KaKb(fix,fix))\...
				 -KaKb(fix,fix)*gl_T2(fix)...
				 +KaKb(fix,dof)*gl_F(dof)...
				 -Ka(fix,fix)*gl_u(fix)...
				 -Ka(fix,dof)*gl_u(dof);
end   
