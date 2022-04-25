%--------------------------------------------------------------------------
% Solve a kelvin-voigt linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u, T]  = eulerKV(u_t, dof, fix, dt, k, F_t, T_t, K, BB, Mat)
    eta = Mat.visco;
	
	u = u_t(:,k+1); T = T_t(:,k+1);
	
    leftcorr = BB(dof,dof)*u_t(dof,k)...
                 -BB(dof,fix)*(u_t(fix,k+1)-u_t(fix,k))...
                 -(K(dof,fix)*u_t(fix,k)+K(dof,dof)*u_t(dof,k))*dt/eta;
    u(dof) = BB(dof,dof)\(leftcorr+F_t(dof, k)*(dt/eta));

    T(fix) = K(fix,fix)*u_t(fix,k)+K(fix,dof)*u_t(dof,k)+...
                 BB(fix,fix)*(u_t(fix,k+1)-u_t(fix,k))*eta/dt+...
                 BB(fix,dof)*(u_t(dof,k+1)-u_t(dof,k))*eta/dt;
end
