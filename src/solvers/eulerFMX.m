%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u, T] = eulerFMX(u, dof, fix, dt, k, F, T, K, BB, Mat)

    gl_eps = glderiv(u,k-1,dt,Mat.alpha,2,1e6);
    gl_eps = gl_eps*dt^(Mat.alpha);

    u(dof,k) = BB(dof,dof)\(F(dof)*dt^(Mat.alpha)/Mat.c_alpha)-gl_eps(dof);
    
%     F_k(fix)   = (BB(fix,fix)*(u_kp1(fix)-u_k(fix)) + ...
%                   BB(fix,dof)*(u_kp1(dof)-u_k(dof)))*eta/dt;

%     stress_kp1 = (eye(size(D)) - dt*D/eta)*stress_k+ D*Bvec*(u_kp1-u_k);
    % TODO TODO FIXIT BROKEN
%     stress_kp1 = stress_k;
end   
