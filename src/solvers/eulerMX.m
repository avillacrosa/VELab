%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u, T] = eulerMX(u_t, dof, fix, dt, k, F_t, T_t, K, BB, Mat)
    eta  = Mat.visco;

	u = u_t(:,k+1); T = T_t(:,k+1);
	
    fdot = (F_t(:,k+1)-F_t(:,k))/dt;
    u_e   = K(dof,dof)\fdot(dof); 
    
    u(dof) = BB(dof,dof)\(BB(dof,dof)*u_e/eta+...
                    -BB(dof,fix)*(u_t(fix,k+1)-u_t(fix,k))+...
                    F_t(dof)*dt/eta)+u_t(dof,k);
    T(fix)   = (BB(fix,fix)*(u_t(fix,k+1)-u_t(fix,k)) + ...
                  BB(fix,dof)*(u_t(dof,k+1)-u_t(dof,k)))*eta/dt;
    
end   
