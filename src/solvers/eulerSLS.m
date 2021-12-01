%--------------------------------------------------------------------------
% Solve a maxwell linear viscoelastic system (hookean elasticity)
% using either forward or backward euler's method
%--------------------------------------------------------------------------
function [u_kp1, stress_kp1, F_k] = eulerMX(u_k, u_kp1, stress_k, F_k, ...
                                                    K, BB, Geo, Set, Mat)
    dt   = Set.dt;
    eta  = Mat.visco;

    % Get integrals at equilibrium
    dof = Geo.dof;
    fix = Geo.fix;
    % K, Btot and Bvec are global
    % TODO FIXIT This is bad but since is 0 we get away with it
    fdot = zeros(size(Geo.F));
    u_e   = K(dof,dof)\fdot(dof); 
    
    u_kp1(dof) = BB(dof,dof)\(BB(dof,dof)*u_e/eta+...
                    -BB(dof,fix)*(u_kp1(fix)-u_k(fix))+...
                    F_k(dof)*dt/eta)+u_k(dof);
    F_k(fix)   = (BB(fix,fix)*(u_kp1(fix)-u_k(fix)) + ...
                  BB(fix,dof)*(u_kp1(dof)-u_k(dof)))*eta/dt;

%     stress_kp1 = (eye(size(D)) - dt*D/eta)*stress_k+ D*Bvec*(u_kp1-u_k);
    % TODO TODO FIXIT BROKEN
    stress_kp1 = stress_k;
end   
