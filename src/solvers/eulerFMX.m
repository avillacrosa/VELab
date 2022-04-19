%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u, T] = eulerFMX(u, k, F, T, K, BB, Geo, Set, Mat)

    gl_eps = glderiv(u,k-1,Set.dt,Mat.alpha,2,1e6);
    gl_eps = gl_eps*Set.dt^(Mat.alpha);

    dof = Geo.dof; fix = Geo.fix;

    u(dof,k) = BB(dof,dof)\(F(dof)*Set.dt^(Mat.alpha)/Mat.c_alpha)-gl_eps(dof);
    
%     F_k(fix)   = (BB(fix,fix)*(u_kp1(fix)-u_k(fix)) + ...
%                   BB(fix,dof)*(u_kp1(dof)-u_k(dof)))*eta/dt;

%     stress_kp1 = (eye(size(D)) - dt*D/eta)*stress_k+ D*Bvec*(u_kp1-u_k);
    % TODO TODO FIXIT BROKEN
%     stress_kp1 = stress_k;
end   
