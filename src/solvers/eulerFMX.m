%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_kp1, stress_kp1, F_k] = eulerFMX(u, k, stress_k, F_k, K, BB, Geo, Set, Mat)
    dt   = Set.dt;
    eta  = Mat.visco;

    frac_term = zeros(size(u,1));
    lambda = 1;
    for j = 2:(k)
        frac_term = u(:,k) + lambda*u(:,k-j+1);
        lambda = lambda*(j-1-Mat.alpha)/j;
    end

    dof = Geo.dof;

    u_kp1(dof) = BB(dof,dof)\(F_k(dof)*Mat.alpha/Mat.c_alpha)-frac_term(dof);
    
%     F_k(fix)   = (BB(fix,fix)*(u_kp1(fix)-u_k(fix)) + ...
%                   BB(fix,dof)*(u_kp1(dof)-u_k(dof)))*eta/dt;

%     stress_kp1 = (eye(size(D)) - dt*D/eta)*stress_k+ D*Bvec*(u_kp1-u_k);
    % TODO TODO FIXIT BROKEN
    stress_kp1 = stress_k;
end   
